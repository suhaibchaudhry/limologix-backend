class TripNotification < ActiveRecord::Base
  KINDS = ['request', 'cancel']
  scope :request, -> { where(kind: 'request') }
  scope :cancel, -> { where(kind: 'cancel') }

  belongs_to :driver
  belongs_to :trip

  after_create :send_notification

  private

  def send_notification
    response = Fcm.publish_to_topic(driver.topic, title, body, TripSerializer.new(trip))
    self.update(status: response[:status], response: response[:message])
  end
end
