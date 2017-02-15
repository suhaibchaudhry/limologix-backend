class TripRequestWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'trip_requests', retry: false

  def perform(source_place_id, end_place_id, trip_id=nil, driver_id=nil)
    trip = Trip.find_by(id: trip_id)

    if trip.present?
      trip.dispatch! if trip.pending?

      unless trip.pick_up_at + 10.minutes < Time.now.utc
        if driver_id.present?
          driver = Driver.find_by(id: driver_id)
          notification_data = TripSerializer.new(trip).serializable_hash.merge({notified_at: Time.now, source_place_id: source_place_id, destination_place_id: end_place_id}).to_json
          notification = trip.request_notifications.create(driver_id: driver.id,
            title: Settings.mobile_notification.trip_request.title, body: Settings.mobile_notification.trip_request.body,
            data: notification_data)
        end

        nearest_driver = trip.find_nearest_driver
        if nearest_driver.present?
          TripRequestWorker.perform_in(Settings.delay_between_trip_request.seconds, source_place_id, end_place_id, trip.id, nearest_driver.id)
          nearest_driver.manage_toll_insufficiency if !nearest_driver.has_enough_toll_credit?
        else
          TripRequestWorker.perform_in(Settings.delay_between_trip_request.seconds, source_place_id, end_place_id, trip.id, nil)
        end
      else
        trip.inactive! if trip.dispatched?
      end
    end
  end
end