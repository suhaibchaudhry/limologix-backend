module V1
  module Drivers
    class TripsEndpoint < Root
      before do
        authenticate!
      end

      namespace :drivers do
        namespace :trips do

          desc 'Accept trip.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Trip accepted successfully.'}.to_json },
              { code: 404,
                message: {
                  status: 'error',
                  message: 'Trip not found.',
                }.to_json
              },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Trip has already been dispatched.',
                }.to_json
              }]
          end
          params do
            requires :trip, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'accept' do
            trip  = Trip.find_by(id: params[:trip][:id])
            error!("Trip not found." , 404) unless trip.present?
            error!("Trip has been closed or cancelled." , 401) if trip.closed? || trip.cancelled?
            error!("You have already accepted this trip." , 401) if trip.active? && current_driver.trips.active.first == trip
            error!("You cannot accept this trip because you are part of some other trip.") if current_driver.has_active_trip?
            error!("Trip has already been dispatched." , 401) if trip.active?
            error!("Right now you are in Invisible status." , 401) unless current_driver.visible

            dispatch = current_driver.dispatches.new(trip_id: trip.id)
            if dispatch.save
              trip.update_status_to_active!
              {
                message: 'Trip accepted successfully.',
              }
            else
              error!(error_formatter(dispatch) , 401)
            end
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
            requires :trip, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'show' do
            trip = Trip.find_by(id: params[:trip][:id])
            error!("Trip not found." , 404) unless trip.present?
            error!("Trip has been closed or cancelled." , 401) if trip.closed? || trip.cancelled?
            error!("Trip has already been dispatched." , 401) if trip.active?
              {
                message: 'Trip details.',
                data: {
                  trip: serialize_model_object(trip)
                }
              }
          end

        end
      end
    end
  end
end