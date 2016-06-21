module V1
  module Drivers
    class ProfilesEndpoint < Root
      before do
        authenticate!
      end

      helpers do
        def contact_info_params
          params[:driver][:address_attributes] = params[:driver][:address]

          ActionController::Parameters.new(params).require(:driver).permit(:first_name, :last_name, :email, 
            :mobile_number, address_attributes: [:street, :city, :zipcode, :state_code, :country_code])
        end

        def personal_info_params
          params[:driver][:license_image] = params[:driver][:license_image].present? ? decode_base64_image(params[:driver][:license_image][:name], params[:driver][:license_image][:image]) : nil
          params[:driver][:ara_image] = params[:driver][:ara_image].present? ? decode_base64_image(params[:driver][:ara_image][:name], params[:driver][:ara_image][:image]) : nil

          ActionController::Parameters.new(params).require(:driver).permit(:license_number, :license_expiry_date, :license_image,
            :badge_number, :badge_expiry_date, :ara_number,:ara_image, :ara_expiry_date, :insurance_company, 
            :insurance_policy_number, :insurance_expiry_date)
        end

        def vehicle_params
          params[:vehicle][:features] = params[:vehicle][:features].present? ? params[:vehicle][:features].join(",") : nil
          ActionController::Parameters.new(params).require(:vehicle).permit(:make, :model,
            :hll_number, :color, :license_plate_number, :features)
        end
      end

      namespace :drivers do
        namespace :profile do
          desc 'Update contact information.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }
            http_codes [ { code: 201, message: { status: 'success', message: 'Contact Information updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Driver first name is missing, Driver last name is empty'
                }.to_json
              }]
          end
          params do
            requires :driver, type: Hash do
              requires :first_name, type: String, allow_blank: false
              requires :last_name, type: String, allow_blank: false
              requires :mobile_number, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false

              requires :address, type: Hash do
                requires :street, type: String, allow_blank: false
                requires :city, type: String, allow_blank: false
                requires :zipcode, type: Integer, allow_blank: false
                requires :state_code, type: String, allow_blank: false
                requires :country_code, type: String, allow_blank: false
              end
            end
          end
          post 'update_contact_information' do

            if current_driver.update(contact_info_params)
              { message: 'Contact information updated successfully.'}
            else
              error!(error_formatter(current_driver) , 401)
            end
          end

          desc 'Update personal information.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }
            http_codes [ { code: 201, message: { status: 'success', message: 'Personal information updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Driver license number is missing, Driver license number is empty'
                }.to_json
              }]
          end
          params do
            requires :driver, type: Hash do
              requires :license_number, type: String, allow_blank: false
              requires :license_expiry_date, type: Date, allow_blank: false
              requires :license_image, type: Hash do
                requires :name, type: String, allow_blank: false
                requires :image, type: String, allow_blank: false
              end

              requires :badge_number, type: String, allow_blank: false
              requires :badge_expiry_date, type: Date, allow_blank: false

              requires :ara_number, type: String, allow_blank: false
              requires :ara_expiry_date, type: Date, allow_blank: false
              requires :ara_image, type: Hash do
                requires :name, type: String, allow_blank: false
                requires :image, type: String, allow_blank: false
              end
              requires :insurance_company, type: String, allow_blank: false
              requires :insurance_policy_number, type: String, allow_blank: false
              requires :insurance_expiry_date, type: Date, allow_blank: false
            end
          end
          post 'update_personal_information' do

            if current_driver.update(personal_info_params)
              { message: 'Personal information updated successfully.'}
            else
              error!(error_formatter(current_driver) , 401)
            end
          end


          desc 'Update visible status.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }
            http_codes [ { code: 201, message: { status: 'success', message: 'Personal information updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Driver visible is missing, Driver visible is empty'
                }.to_json
              }]
          end
          params do
            requires :driver, type: Hash do
              requires :visible, type: Boolean, allow_blank: false
            end
          end
          post 'update_visible_status' do

            if current_driver.update(visible: params[:driver][:visible])
              { message: 'Visible status updated successfully.'}
            else
              error!(error_formatter(current_driver) , 401)
            end
          end


          desc 'Update password' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Password has been updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Driver password is empty'
                }.to_json
              }]
          end
          params do
            requires :driver, type: Hash do
              requires :password, type: String, allow_blank: false
            end
          end
          post 'reset_authentication_details' do
            if current_driver.update(password: params[:driver][:password], auth_token: nil)
              { message: 'Password has been updated successfully.'}
            else
              error!(error_formatter(current_driver) , 401)
            end
          end

          desc 'Get channel name' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 401, message: { status: 'error', message: 'Unauthorized. Invalid or expired token.'}.to_json }]
          end
          get 'channel' do
            {
              message: 'Channel.',
              data: {
                channel: current_driver.channel
              }
            }
          end

          desc 'update a vehicle.' do
            headers 'Auth-Token' => { description: 'Validates your identity', required: true }

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
              requires :make, type: String, allow_blank: false
              requires :model, type: String, allow_blank: false
              requires :hll_number, type: String, allow_blank: false
              requires :color, type: String, allow_blank: false
              requires :license_plate_number, type: String, allow_blank: false
              requires :vehicle_type_id, type: Integer, allow_blank: false
              optional :features, type: Array[String]
            end
          end
          post 'update_vehicle' do
            vehicle_type = VehicleType.find_by(id: params[:vehicle][:vehicle_type_id])
            error!("Vehicle Type not found." , 404) unless vehicle_type.present?

            vehicle = current_driver.vehicle
            error!("Vehicle not found." , 404) unless vehicle.present?

            if vehicle.update(vehicle_params)
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