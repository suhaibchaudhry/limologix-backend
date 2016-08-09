class FayeClient
  require 'eventmachine'

  def self.send_notification(channel, data)
    publication_status = false
    EM.run {
      client = Faye::Client.new("http://localhost:9293/faye")

      publication = client.publish("/publish/#{channel}", data)

      publication.callback do
        client.disconnect();
        publication_status = true
        EM.stop
      end

      publication.errback do |error|
        client.disconnect();
        puts " <<<<<<<<osadsadsad"
        publication_status = false
        EM.stop
      end
    }

    publication_status ? "success" : "error"
  end
end