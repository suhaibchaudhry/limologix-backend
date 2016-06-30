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
            :badge_number, :badge_expiry_date,:ara_image, :ara_expiry_date, :insurance_company, 
            :insurance_policy_number, :insurance_expiry_date)
        end

        def vehicle_params
          params[:vehicle][:features_attributes] = params[:vehicle][:features].present? ? params[:vehicle][:features].map{|feature| {name: feature}} : []
          ActionController::Parameters.new(params).require(:vehicle).permit(:hll_number, :color, :license_plate_number, features_attributes: [:name])
        end
      end

      namespace :drivers do
        namespace :profile do
          desc 'Get driver details.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [
              {
                code: 200,
                message: {
                  status: 'success',
                  message: 'Drivers details.',
                  data: {
                    driver: {
                      id: 1,
                      first_name: 'Avinash',
                      last_name: 'T',
                      mobile_number: '78787878',
                      email: 'avinash123@yopmail.com',
                      license_number: 'L456',
                      license_expiry_date: '2016-06-08',
                      license_image: {
                        name: 'License.jpg',
                        image: '/uploads/driver/license_image/1/License.jpg'
                      },
                      badge_number: 'B456',
                      badge_expiry_date: '2016-06-08',
                      ara_image: {
                        name: 'ARA.jpg',
                        image: '/uploads/driver/ara_image/1/ARA.jpg'
                      },
                      ara_expiry_date: '2016-06-08',
                      insurance_company: 'LIMO',
                      insurance_policy_number: 'IN456',
                      insurance_expiry_date: '2016-06-08',
                      status: 'pending',
                      address: {
                        street: 'adsdasdasdasd',
                        city: 'texas',
                        zipcode: 52014,
                        state: {
                          code: 'AL',
                          name: 'Alabama'
                        },
                        country: {
                          code: 'US',
                          name: 'United States'
                        }
                      }
                    }
                  }
                }.to_json
              },
              { code: 201, message: { status: 'success', message: 'No results found.'}.to_json }]
          end
          get 'show' , serializer: DriverVehicleSerializer do
            {
              message: 'Drivers details.',
              data: {
                driver: serialize_model_object(current_driver)
              }
            }
          end

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
            check_whether_driver_approved

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

          desc 'Get vehicle information.' do
            headers 'Auth-Token' => { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Vehicle details.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Vehicle make is missing, Vehicle make is empty'
                }.to_json
              }]
          end
          get 'get_vehicle' do
            vehicle = current_driver.vehicle

            if vehicle.present?
              {
                message: 'Vehicle details.',
                data: {
                  vehicle: serialize_model_object(vehicle)
                }
              }
            else
             error!("Vehicle not found." , 404)
            end
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
              requires :vehicle_make_id, type: Integer, allow_blank: false
              requires :vehicle_model_id, type: Integer, allow_blank: false
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

            vehicle_make = VehicleMake.find_by(id: params[:vehicle][:vehicle_make_id])
            error!("Vehicle make not found." , 404) unless vehicle_make.present?

            vehicle_make_type = VehicleMakeType.where(vehicle_type_id: vehicle_type.id, vehicle_make_id: vehicle_make.id).first
            error!("Vehicle model of this type or make not found." , 404) unless vehicle_make_type.present?

            vehicle_model = VehicleModel.find_by(id: params[:vehicle][:vehicle_model_id])
            error!("Vehicle model not found." , 404) unless vehicle_model.present?

            vehicle = current_driver.vehicle
            error!("Vehicle not found." , 404) unless vehicle.present?

            vehicle.vehicle_type = vehicle_type
            vehicle.vehicle_make = vehicle_make
            vehicle.vehicle_model = vehicle_model

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