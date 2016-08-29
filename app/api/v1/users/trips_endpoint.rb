module V1
  module Users
    class TripsEndpoint < Root
      before do
        authenticate!
      end

      helpers do

        params :geolocation do
          requires :place, type: String, allow_blank: false
          requires :latitude, type: String, allow_blank: false
          requires :longitude, type: String, allow_blank: false
        end

        def trip_params
          params[:trip][:start_destination_attributes] = params[:trip][:start_destination]
          params[:trip][:end_destination_attributes] = params[:trip][:end_destination]

          ActionController::Parameters.new(params).require(:trip).permit(:pick_up_at, :passengers_count, start_destination_attributes: [:place,
            :latitude, :longitude], end_destination_attributes: [:place, :latitude, :longitude])
        end
      end

      namespace :users do
        namespace :trips do

          desc 'Trip creation.'
          params do
            requires :trip, type: Hash do
              requires :start_destination, type: Hash do
                use :geolocation
              end

              requires :end_destination, type: Hash do
                use :geolocation
              end

              requires :pick_up_at, type: DateTime, allow_blank: false
              requires :passengers_count, type: Integer, allow_blank: false
              requires :customer_id, type: Integer, allow_blank: false
              requires :vehicle_type_id, type: Integer, allow_blank: false
              requires :group_ids, type: Array[Integer], allow_blank: false
            end
          end
          post 'create' do
            trip  = current_user.trips.new(trip_params)

            customer = current_user.company.customers.where(id: params[:trip][:customer_id]).first
            error!("Customer not found." , 404) unless customer.present?

            vehicle_type = VehicleType.find_by(id: params[:trip][:vehicle_type_id])
            error!("Vehicle Type not found." , 404) unless vehicle_type.present?

            begin
              trip.group_ids = params[:trip][:group_ids]
            rescue => e
              error!("Couldn't find all Groups" , 400)
            end

            if trip.valid?
              trip.assign_attributes(customer: customer, vehicle_type: vehicle_type)
              trip.save
              # TripRequestWorker.perform_at((trip.pick_up_at-15.minutes), trip.id)
              TripRequestWorker.perform_async(trip.id)

              {
                message: 'Trip created successfully.',
                data: {
                  trip: serialize_model_object(trip)
                }
              }
            else
              error!(trip.errors.full_messages , 400)
            end
          end

          desc 'Trips list based on status.'
          params do
            requires :trip_status, type: String, allow_blank: false
          end
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index', each_serializer: TripsArraySerializer  do
            error!('Invalid trip status.', 404) unless Trip::STATUSES.include?(params[:trip_status])

            trips = paginate(current_user.trips.send(params[:trip_status]).order(:created_at).reverse_order)
            if trips.present?
              {
                message: 'Trips list.',
                data: {
                  trips: serialize_model_object(trips)
                }
              }
            else
              { message: 'No results found.'}
            end
          end

          desc 'Get Trip details..'
          params do
            requires :trip_id, type: Integer, allow_blank: false
          end
          post 'show' do
            trip = current_user.trips.find_by(id: params[:trip_id])

            if trip.present?
              {
                message: 'Trip details.',
                data: {
                  trip: serialize_model_object(trip)
                }
              }
            else
              error!('Trip not found.', 404)
            end
          end

          desc 'Trip cancel API.'
          params do
            requires :trip_id, type: Integer, allow_blank: false
          end
          post 'cancel' do
            trip = current_user.trips.find_by(id: params[:trip][:id])

            error!("Trip not found.", 404) unless trip.present?

            if trip.active_dispatch.present?
              trip.mobile_notifications.create(
                driver_id: trip.active_dispatch.driver_id,
                title: Settings.mobile_notification.trip_cancellation.title,
                body: Settings.mobile_notification.trip_cancellation.body,
                data: {
                  status: 'trip_cancellation'
                }.to_json
              )

              trip.active_dispatch.cancel!
            end

            trip.cancel!

            { message: 'Trip has been cancelled successfully.' }
          end
        end
      end
    end
  end
end