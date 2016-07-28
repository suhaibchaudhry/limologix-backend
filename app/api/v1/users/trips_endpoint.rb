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

          desc 'Trip creation.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Trip created successfully.',
                data: {
                  trip: {"id":1,"start_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"123.33"},
                  "end_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"1.2.31.56"},
                  "pick_up_at":"2016-05-19T15:43:58.000Z","passengers_count":22 }
                  }}.to_json },
              { code: 404,
                message: {
                  status: 'error',
                  message: 'Customer not found.',
                }.to_json
              },
              { code: 400,
                message: {
                  status: 'error',
                  message: 'Trip start destination is missing, Trip end destination is empty',
                }.to_json
              }]
          end
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
            end
          end
          post 'create' do
            trip  = current_user.trips.new(trip_params)

            customer = current_user.company.customers.where(id: params[:trip][:customer_id]).first
            error!("Customer not found." , 404) unless customer.present?

            vehicle_type = VehicleType.find_by(id: params[:trip][:vehicle_type_id])
            error!("Vehicle Type not found." , 404) unless vehicle_type.present?

            if trip.valid?
              trip.customer = customer
              trip.vehicle_type = vehicle_type
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

          desc 'Trips list based on status.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Trips list.',
              data: {
                trips: [{"id":1,"start_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"123.33"},
                "end_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"1.2.31.56"},
                "pick_up_at":"2016-05-19T15:43:58.000Z","passengers_count":22 ,
                "customer":{"id":7,"first_name":"customer1","last_name":"t","email":"ac@gmail.com","mobile_number":"123","full_name":"customer1 t","organisation":"tcs"}},
                {"id":1,"start_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"123.33"},
                  "end_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"1.2.31.56"},"pick_up_at":"2016-05-19T15:43:58.000Z","passengers_count":22,
                  "customer":{"id":7,"first_name":"customer1","last_name":"t","email":"ac@gmail.com","mobile_number":"123","full_name":"customer1 t","organisation":"tcs"}}]
              }
            }.to_json }]
          end
          params do
            requires :trip_status, type: String, allow_blank: false
          end
          post 'index', each_serializer: TripsArraySerializer  do
            error!('Invalid trip status.', 404) unless Trip::STATUSES.include?(params[:trip_status])
            trips = current_user.trips.send(params[:trip_status])
            {
              message: 'Trips list.',
              data: {
                trips: serialize_model_object(trips)
              }
            }
          end

          desc 'Get Trip details..' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Trip details.',
              data: {
                trip: {"id":1,"start_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"123.33"},
                "end_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"1.2.31.56"},
                "pick_up_at":"2016-05-19T15:43:58.000Z","passengers_count":22 }
              }
            }.to_json },
            { code: 404,
              message: {
                status: 'error',
                message: 'Trip not found.',
              }.to_json
            }]
          end
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

          desc 'Trip Update.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Trip updated successfully.',
                data: {
                  trip: {"id":1,"start_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"123.33"},
                  "end_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"1.2.31.56"},
                  "pick_up_at":"2016-05-19T15:43:58.000Z","passengers_count":22 }
                  }}.to_json },
              { code: 400,
                message: {
                  status: 'error',
                  message: 'Trip start destination is missing, Trip end destination is empty',
                }.to_json
              }]
          end
          params do
            requires :trip, type: Hash do
              requires  :id, type: Integer, allow_blank: false
              requires :start_destination, type: Hash do
                use :geolocation
              end

              requires :end_destination, type: Hash do
                use :geolocation
              end

              requires :pick_up_at, type: DateTime, allow_blank: false
              requires :passengers_count, type: Integer, allow_blank: false
            end
          end
          post 'update' do
            trip  = current_user.trips.find_by(id: params[:trip][:id])
            error!("Trip not found." , 404) unless trip.present?

            if trip.update(trip_params)
              {
                message: 'Trip updated successfully.',
                data: {
                  trip: serialize_model_object(trip)
                }
              }
            else
              error!(trip.errors.full_messages , 400)
            end
          end

          desc 'Trip cancel API.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Trip has been  cancelled successfully.'}.to_json },
            { code: 404,
              message: {
                status: 'error',
                message: 'Trip not found.',
              }.to_json
            }]
          end
          params do
            requires :trip, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'cancel' do
            trip = current_user.trips.find_by(id: params[:trip][:id])
            error!("Trip not found." , 404) unless trip.present?

            trip.cancel!
            { message: 'Trip has been cancelled successfully.' }
          end
        end
      end
    end
  end
end