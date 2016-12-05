class Fcm
  URL = 'https://fcm.googleapis.com/fcm/send'

  def self.publish_to_topic(topic, title, body, data )
    # Android takes only the data block, hence merging title and body into data key.
    notification_block = {
      title: title,
      body: body,
      sound: "default",
      click_action: "FCM_PLUGIN_ACTIVITY"
    }
    begin
      args = {
        to: "/topics/#{topic}",
        priority: 'high',
        data: data.merge(notification_block),
        notification: notification_block
      }

      driver_record = $redis.hgetall("drivers")[topic]
      device_type = JSON.parse(driver_record)['platform'].downcase
      response = do_post_request(args, device_type)

      if response.code == "200"
        { status: "success", message: response.body }
      else
        { status: "error", message:  response.body, code: response.code }
      end
    rescue Exception => e
      { status: "exception", message: e.message }
    end
  end

  private

  def self.do_post_request(args, device_type)
    uri = URI.parse(URL)

    headers = {
      "Authorization" => "key=#{Rails.application.secrets.fcm_authorization_key[device_type]}",
      "Content-Type" => "application/json"
    }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri, initheader = headers)
    req.body = args.to_json
    result = http.request(req)
  end
end
