module V1
  module Drivers
    class VehiclesEndpoint < Root
      before do
        authenticate!
      end

      helpers do
        params :vehicle_attributes do
          requires :make, type: String, allow_blank: false
          requires :model, type: String, allow_blank: false
          requires :hll_number, type: String, allow_blank: false
          requires :color, type: String, allow_blank: false
          requires :license_plate_number, type: String, allow_blank: false
          requires :vehicle_type_id, type: Integer, allow_blank: false
          optional :features, type: Array[String]
        end

        def vehicle_params
          params[:vehicle][:features] = params[:vehicle][:features].present? ? params[:vehicle][:features].join(",") : nil
          ActionController::Parameters.new(params).require(:vehicle).permit(:make, :model,
            :hll_number, :color, :license_plate_number, :features)
        end
      end

      namespace :drivers do
        namespace :vehicles do

          desc 'Add a vehicle.' do
            # headers "Auth-Token": { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Vehicle added successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Vehicle make is missing, Vehicle make is empty'
                }.to_json
              }]
          end
          params do
            requires :vehicle, type: Hash do
              use :vehicle_attributes
            end
          end
          post 'create' do
            vehicle_type = VehicleType.find_by(id: params[:vehicle][:vehicle_type_id])
            error!("Vehicle Type not found." , 404) unless vehicle_type.present?

            vehicle = current_driver.vehicles.new(vehicle_params)
            vehicle.vehicle_type = vehicle_type

            if vehicle.save
              { message: 'Vehicle added successfully.' }
            else
              error!(error_formatter(vehicle) , 401)
            end
          end


          desc 'update a vehicle.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Vehicle updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Vehicle make is missing, Vehicle make is empty'
                }.to_json
              }]
          end
          params do
            requires :vehicle, type: Hash do
              requires :id, type: Integer, allow_blank: false
              use :vehicle_attributes
            end
          end
          post 'update' do
            vehicle_type = VehicleType.find_by(id: params[:vehicle][:vehicle_type_id])
            error!("Vehicle Type not found." , 404) unless vehicle_type.present?

            vehicle = current_driver.vehicles.find_by(id: params[:vehicle][:id])
            vehicle.vehicle_type = vehicle_type

            if vehicle.save
              { message: 'Vehicle updated successfully.' }
            else
              error!(error_formatter(vehicle) , 401)
            end
          end

        end
      end
    end
  end
end