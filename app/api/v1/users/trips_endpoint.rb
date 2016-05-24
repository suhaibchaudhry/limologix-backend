module V1
  module Users
    class TripsEndpoint < Root
      before do
        authenticate!
      end

      helpers do
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
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Trip start destination is missing, Trip end destination is empty',
                }.to_json
              }]
          end
          params do
            requires :trip, type: Hash do
              requires :start_destination, type: Hash do
                requires :place, type: String, allow_blank: false
                requires :latitude, type: String, allow_blank: false
                requires :longitude, type: String, allow_blank: false
              end

              requires :end_destination, type: Hash do
                requires :place, type: String, allow_blank: false
                requires :latitude, type: String, allow_blank: false
                requires :longitude, type: String, allow_blank: false
              end

              requires :pick_up_at, type: DateTime, allow_blank: false
              requires :passengers_count, type: Integer, allow_blank: false
              requires :customer_id, type: Integer, allow_blank: false
            end
          end
          post 'create' do
            trip  = current_user.trips.new(trip_params)

            customer = current_user.company.customers.where(id: params[:trip][:customer_id]).first
            error!("Customer not found." , 401) unless customer.present?

            if trip.valid?
              trip.customer = customer
              trip.save

              {
                message: 'Trip created successfully.',
                data: {
                  trip: serialize_model_object(trip)
                }
              }
            else
              error!(error_formatter(trip) , 401)
            end
          end

          desc 'Trips list based on status.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Trips list.',
              data: {
                trips: [{"id":1,"start_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"123.33"},
                "end_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"1.2.31.56"},
                "pick_up_at":"2016-05-19T15:43:58.000Z","passengers_count":22 },
                {"id":1,"start_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"123.33"},
                  "end_destination":{"place":"bangalore","latitude":"1.2.31.56","longitude":"1.2.31.56"},
                  "pick_up_at":"2016-05-19T15:43:58.000Z","passengers_count":22 }]
              }
            }.to_json }]
          end
          params do
            requires :trip_status, type: String, allow_blank: false
          end
          post 'index' do
            {
              message: 'Trips list.',
              data: {
                trips: serialize_model_object(current_user.trips)
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

        end
      end
    end
  end
end