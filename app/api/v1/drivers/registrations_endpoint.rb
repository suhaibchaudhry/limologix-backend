module V1
  module Drivers
    class RegistrationsEndpoint < Root
      helpers do
        def driver_params
          params[:driver][:license_image] = params[:driver][:license_image].present? ? decode_base64_image(params[:driver][:license_image][:name], params[:driver][:license_image][:image]) : nil
          params[:driver][:ara_image] = params[:driver][:ara_image].present? ? decode_base64_image(params[:driver][:ara_image][:name], params[:driver][:ara_image][:image]) : nil

          ActionController::Parameters.new(params).require(:driver).permit(:first_name, :last_name,
            :password, :email, :mobile_number, :license_number, :license_expiry_date, :license_image, 
            :badge_number, :badge_expiry_date, :ara_number,:ara_image, :ara_expiry_date, :insurance_company, 
            :insurance_policy_number, :insurance_expiry_date)
        end

        def vehicle_params
          ActionController::Parameters.new(params).require(:vehicle).permit(:make, :model,
            :hll, :color, :license_plate, :features)
        end
      end

      namespace :drivers do
        desc 'Creates a driver account' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Registration successfull.', data: {'Auth-Token': 'HDGHSDGSD4454', email: "mahesh@yopmail.com"} }.to_json },
            { code: 401,
              message: {
                status: 'error',
                message: 'Driver email has already been taken'
              }.to_json
            }
          ]
        end
        params do
          requires :driver, type: Hash do
            requires :first_name, type: String, allow_blank: false
            requires :last_name, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
            requires :mobile_number, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false

            optional :address, type: Hash do
              optional :street, type: String
              optional :city, type: String
              optional :zipcode, type: Integer
              optional :state_code, type: String
              optional :country_code, type: String
            end

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

          requires :vehicle, type: Hash do
            requires :make, type: String, allow_blank: false
            requires :model, type: String, allow_blank: false
            requires :hll, type: String, allow_blank: false
            requires :color, type: String, allow_blank: false
            requires :license_plate, type: String, allow_blank: false
            requires :vehicle_type_id, type: Integer, allow_blank: false
            optional :features, type: String
          end
        end
        post 'registration' do
          vehicle_type = VehicleType.find_by(id: params[:vehicle][:vehicle_type_id])
          error!("VehicleType not found." , 404) unless vehicle_type.present?

          driver = Driver.new(driver_params)
          vehicle = driver.vehicles.new(vehicle_params)

          if driver.valid? && vehicle.valid?
            driver.save
            vehicle.vehicle_type = vehicle_type
            vehicle.save

            {
              message: 'Registration successfull.',
              data: {
                'Auth-Token': driver.auth_token,
                full_name: driver.full_name
              }
            }
          else
            error!(error_formatter(driver) , 401)
          end
        end
      end
    end
  end
end