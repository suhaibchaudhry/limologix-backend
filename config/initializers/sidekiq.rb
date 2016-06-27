Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
  config.average_scheduled_poll_interval = 5
  config.utc = true
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end