class WebNotification < ActiveRecord::Base

  KINDS = ['trip_accept']

  belongs_to :notifiable, :polymorphic => true
  belongs_to :publishable, :polymorphic => true

  after_create :send_notification

  private

  def send_notification
    response = FayeClient.send_notification(self.publishable.channel, self.message)
    self.update(response_status: response)
  end
end