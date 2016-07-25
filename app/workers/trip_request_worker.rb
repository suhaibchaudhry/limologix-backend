class TripRequestWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'trip_requests', retry: false

  def perform(trip_id=nil, driver_id=nil)
    trip = Trip.find_by(id: trip_id)
    trip.dispatch! if trip.pending?

    unless trip.pick_up_at < Time.now
      if driver_id.present?
        driver = Driver.find_by(id: driver_id)
        notification_data = TripSerializer.new(trip).serializable_hash.merge({notified_at: Time.now}).to_json
        notification = trip.request_notifications.create(driver_id: driver.id, title: "Limo Logix", body: "YOU’VE GOT A RIDE REQUEST.",
          data: notification_data)
      end

      nearest_driver = trip.nearest_driver
      if nearest_driver.present?
        TripRequestWorker.perform_in(7.seconds, trip.id, nearest_driver)
      else
        puts "Send notification to admin that no driver is available in 20 miles radius"
      end
    else
      trip.reject!
    end
  end
end