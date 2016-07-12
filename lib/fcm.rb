class Fcm
  HEADERS = {
    "Authorization" => "key=#{Rails.application.secrets.fcm_authorization_key}",
    "Content-Type" => "application/json"
  }
  URL = 'https://fcm.googleapis.com/fcm/send'

  def self.publish_to_topic(topic, message)
    begin
      args = {
        to: "/topics/#{topic}",
        priority: 'high',
        data: message,
        notification: {
          title: "Notification title",
          body: "Notification body",
          sound: "default",
          click_action: "FCM_PLUGIN_ACTIVITY",
          icon: "fcm_push_icon"
        }
      }
      response = do_post_request(args)

      if response.code == "200"
        { status: "success", body: response.body }
      else
        { status: "error", body:  response.body, code: response.code }
      end
    rescue Exception => e
      { status: "exception", message: e.message }
    end
  end

  private

  def self.do_post_request(args)
    uri = URI.parse(URL)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri, initheader = HEADERS)
    req.body = args.to_json
    result = http.request(req)
  end
end
