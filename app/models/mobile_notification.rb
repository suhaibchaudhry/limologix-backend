class MobileNotification < ActiveRecord::Base
  KINDS = ['trip_request', 'trip_cancel']

  KINDS.each do |kind|
    scope kind.to_sym, -> { where(kind: kind) }

    define_method("#{kind}?") do
      self.kind == kind
    end
  end

  belongs_to :notifiable, :polymorphic => true
  belongs_to :driver

  after_create :send_notification

  private

  def send_notification
    response = Fcm.publish_to_topic(driver.topic, title, body, JSON.parse(data))
    self.update(status: response[:status], response: response[:message])
  end
end
