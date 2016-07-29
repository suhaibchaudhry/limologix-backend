require 'redis'
require 'rack/cors'
require 'faye'
require 'faye/redis'
require 'byebug'

$redis = Redis.new(url: 'redis://localhost:6379/1')
$redis.ping

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '*', :methods => [:get, :post, :options], :headers => :any
  end
end

Faye::WebSocket.load_adapter('thin')

bayeux = Faye::RackAdapter.new(
  :mount   => '/faye',
  :timeout => 25,
  :engine  => {
    :type  => Faye::Redis,
    :uri  => 'redis://localhost:6379/2'
  }
)

bayeux.on(:publish) do |client_id, channel, data|
  if channel.include?("driver")
    $redis.hset("drivers", channel.split("/").last, data.merge("timestamp" => "#{Time.now.to_i}").to_json)
  end
end

run bayeux