module V1
  module Drivers
    class TripsEndpoint < Root
      before do
        authenticate!
        check_whether_driver_approved
      end

      namespace :drivers do
        namespace :trips do

          desc 'Get Trip details..'
          params do
            requires :trip, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'show' do
            trip = Trip.find_by(id: params[:trip][:id])
            error!('Trip not found.' , 404) unless trip.present?
              {
                message: 'Trip details.',
                data: {
                  trip: serialize_model_object(trip)
                }
              }
          end

          desc 'Accept trip.'
          params do
            requires :trip, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'accept' do
            trip  = Trip.find_by(id: params[:trip][:id])
            error!('Trip not found.' , 404) unless trip.present?
            error!('Trip has been closed or cancelled.' , 403) if trip.closed? || trip.cancelled?
            error!('You have already accepted this trip.' , 403) if trip.active? && trip.active_dispatch.driver == current_driver
            error!('You cannot accept this trip because you are part of some other trip.') if current_driver.active_dispatch.present?
            error!('Trip has already been dispatched.' , 403) if trip.active?
            error!('Right now you are in Invisible status.' , 403) unless current_driver.visible
            error!('You have exceeded the time limit to accept.' , 403) if trip.request_notifications.find_by(driver_id: current_driver).present? && ((Time.now - trip.request_notifications.where(driver_id: current_driver).last.updated_at) > 14)
            error!('You do not have enough toll credit to accept a trip.' , 403) unless current_driver.has_enough_toll_credit?

            trip.active!

            if trip.accept!(current_driver)
              {
                message: 'Trip accepted successfully.',
              }
            else
              error!("Error in dispatching a trip." , 400)
            end
          end

          desc 'Deny trip.'
          params do
            requires :trip, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'deny' do
            trip  = Trip.find_by(id: params[:trip][:id])
            error!('Trip not found.' , 404) unless trip.present?

            trip.active_dispatch.deny! if trip.active_dispatch.present?

            trip.reschedule_worker_to_run_now
            { message: 'Trip denied successfully.' }
          end

          desc 'When passenger on board start the trip.'
          params do
            requires :trip, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'start' do
            trip  = Trip.find_by(id: params[:trip][:id])
            error!('Trip not found.' , 404) unless trip.present?
            error!('This trip is not yet dispatched or cancelled.' , 403) unless trip.active?
            error!('This trip does not belong to you.' , 403) if trip.active? && (trip.active_dispatch.driver != current_driver)
            error!('Trip already started.' , 403) if trip.active_dispatch.started?
            error!('Trip already completed.' , 403) if trip.active_dispatch.completed?

            trip.active_dispatch.start!
            { message: 'Trip started successfully.' }
          end

          desc 'When passenger off board stop the trip.'
          params do
            requires :trip, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'stop' do
            trip  = Trip.find_by(id: params[:trip][:id])
            error!('Trip not found.' , 404) unless trip.present?
            error!('This trip is not yet dispatched or cancelled.' , 403) unless trip.active?
            error!('This trip does not belong to you.' , 403) if trip.active? && (trip.active_dispatch.driver != current_driver)

            error!('Trip not yet started.' , 403) if trip.active_dispatch.yet_to_start?
            error!('Trip already completed.' , 403) if trip.active_dispatch.completed?

            trip.active_dispatch.stop! && trip.close!
            { message: 'Trip stopped successfully.' }
          end
        end
      end
    end
  end
end