class WebNotification < ActiveRecord::Base

  KINDS = ['trip_accept', 'trip_dispatch', 'trip_inactive', 'trip_start', 'trip_stop']

  belongs_to :notifiable, :polymorphic => true
  belongs_to :publishable, :polymorphic => true

  after_create :send_notification

  private

  def send_notification
    channel = self.publishable.channel
    data = JSON.parse(self.message).merge('id' => self.id, 'time' => self.created_at)

    EM.run {
      client = Faye::Client.new("http://localhost:9292/faye")

      publication = client.publish("/#{channel}", data)

      publication.callback do
        self.update(response_status: "success")
        client.disconnect();
      end

      publication.errback do |error|
        client.disconnect();
        self.update(response_status: "error")
      end
    }
  end
end