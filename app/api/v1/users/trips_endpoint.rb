module V1
  module Users
    class TripsEndpoint < Root
      before do
        authenticate!
      end

      helpers do
        def trip_params
          ActionController::Parameters.new(params).require(:trip).permit(:start_destination,
            :end_destination, :pick_up_at)
        end
      end

      namespace :users do
        namespace :trips do

          desc 'Trip creation.' do
            http_codes [ { code: 201, message: { status: 'success', message: 'Trip created successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Trip start destination is empty',
                }.to_json
              }]
          end
          params do
            requires :auth_token, type: String, allow_blank: false
            requires :trip, type: Hash do
              requires :start_destination, type: String, allow_blank: false
              requires :end_destination, type: String, allow_blank: false
              requires :pick_up_at, type: DateTime, allow_blank: false
            end
          end
          post 'create' do
            trip  = Trip.new(trip_params)
            if trip.valid?
              trip.user = current_user
              trip.save
              { message: 'Trip created successfully.' }
            else
              error!(error_formatter(trip) , 401)
            end
          end

          desc 'Trips list based on status.' do
            http_codes [ { code: 201, message: { status: 'success', message: 'Trips list.',
              data: {
                trips: [{"id":1,"start_destination":"fdgdfg","end_destination":"dfgdfg","pick_up_at":"2016-05-13T15:38:00.000Z"},
                  {"id":2,"start_destination":"fdgdfg","end_destination":"dfgdfg","pick_up_at":"2016-05-13T15:38:00.000Z"}]
              }
            }.to_json }]
          end
          params do
            requires :auth_token, type: String, allow_blank: false
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

        end
      end
    end
  end
end