class FayeClient
  require 'eventmachine'

  def self.send_notification(channel, data)
    EM.run {
      client = Faye::Client.new("http://localhost:9292/faye")

      publication = client.publish("/publish/#{channel}", data)

      publication.callback do
        client.disconnect();
        EventMachine::stop_event_loop
        return "success"
      end

      publication.errback do |error|
        client.disconnect();
        EventMachine::stop_event_loop
        return "error"
      end
    }
  end
end