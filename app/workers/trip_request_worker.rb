class TripRequestWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'trip_requests', retry: false

  def perform(trip_id=nil, driver_id=nil)
    trip = Trip.find_by(id: trip_id)

    if trip.present?
      trip.dispatch! if trip.pending?

      unless trip.pick_up_at.utc + 10.minutes < Time.now.utc
        if driver_id.present?
          driver = Driver.find_by(id: driver_id)
          notification_data = TripSerializer.new(trip).serializable_hash.merge({notified_at: Time.now}).to_json

          notification = trip.request_notifications.create(driver_id: driver.id,
            title: Settings.mobile_notification.trip_request.title, body: Settings.mobile_notification.trip_request.body,
            data: notification_data)
        end

        nearest_driver = trip.find_nearest_driver

        if nearest_driver.present? && nearest_driver.has_enough_toll_credit?
          TripRequestWorker.perform_in(Settings.delay_between_trip_request.seconds, trip.id, nearest_driver.id)
        else

          if nearest_driver.present?
            nearest_driver.manage_toll_insufficiency
            nearest_driver.invisible!
          end

          TripRequestWorker.perform_in(Settings.delay_between_trip_request.seconds, trip.id, nil)
        end
      else
        trip.inactive! if trip.dispatched?
      end
    end
  end
end