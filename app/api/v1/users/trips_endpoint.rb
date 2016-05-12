module V1
  module Users
    class TripsEndpoint < Root
      after_validation do
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
          start_destination, :end_destination, :pick_up_at, presence: true
          params do
            requires :auth_token, type: String, allow_blank: false
            requires :trip, type: Hash do
              requires :start_destination, type: String, allow_blank: false
              requires :end_destination, type: String, allow_blank: false
              requires :pick_up_at, type: String, allow_blank: false
            end
          end
          post 'create' do
            trip  = Trip.new(customer_params)
            if trip.valid?
              trip.user = current_user.company
              trip.save
              { message: 'Trip created successfully.' }
            else
              error!(error_formatter(trip) , 401)
            end
          end
        end
      end
    end
  end
end