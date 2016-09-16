module V1
  module Drivers
    class RegistrationsEndpoint < Root
      helpers do
        def driver_params
          params[:driver][:license_image] = params[:driver][:license_image].present? ? decode_base64_image(params[:driver][:license_image][:name], params[:driver][:license_image][:image]) : nil
          params[:driver][:insurance_image] = params[:driver][:insurance_image].present? ? decode_base64_image(params[:driver][:insurance_image][:name], params[:driver][:insurance_image][:image]) : nil
          params[:driver][:ara_image] = params[:driver][:ara_image].present? ? decode_base64_image(params[:driver][:ara_image][:name], params[:driver][:ara_image][:image]) : nil
          params[:driver][:address_attributes] = params[:driver][:address]

          ActionController::Parameters.new(params).require(:driver).permit(:first_name, :last_name, :password, :email, :mobile_number, :company, :license_number, :license_expiry_date, :license_image, :insurance_image, :badge_number, :badge_expiry_date, :ara_number,:ara_image, :ara_expiry_date, :insurance_company, :insurance_policy_number, :insurance_expiry_date, :card_number, :card_expiry_date, :card_code, address_attributes: [:street, :city, :zipcode, :state_code, :country_code, :secondary_address])
        end

        def vehicle_params
          params[:vehicle][:features_attributes] = params[:vehicle][:features].present? ? params[:vehicle][:features].map{|feature| {name: feature}} : []
          ActionController::Parameters.new(params).require(:vehicle).permit(:hll_number, :color, :license_plate_number, features_attributes: [:name])
        end
      end

      namespace :drivers do
        desc 'Creates a driver account'
        params do
          requires :driver, type: Hash do
            requires :first_name, type: String, allow_blank: false
            requires :last_name, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
            requires :mobile_number, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
            requires :company, type: String, allow_blank: false

            requires :address, type: Hash do
              requires :street, type: String, allow_blank: false
              requires :city, type: String, allow_blank: false
              requires :zipcode, type: Integer, allow_blank: false
              requires :state_code, type: String, allow_blank: false
              requires :country_code, type: String, allow_blank: false
              optional :secondary_address, type: String, allow_blank: false
            end

            requires :card_number, type: String, allow_blank: false
            requires :card_expiry_date, type: String, allow_blank: false
            requires :card_code, type: String, allow_blank: false

            requires :license_number, type: String, allow_blank: false
            requires :license_expiry_date, type: Date, allow_blank: false
            requires :license_image, type: Hash do
              requires :name, type: String, allow_blank: false
              requires :image, type: String, allow_blank: false
            end

            requires :insurance_image, type: Hash do
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
        post 'registration' do

          vehicle_type = VehicleType.find_by(id: params[:vehicle][:vehicle_type_id])
          error!("Vehicle type not found." , 404) unless vehicle_type.present?

          vehicle_make = VehicleMake.find_by(id: params[:vehicle][:vehicle_make_id])
          error!("Vehicle make not found." , 404) unless vehicle_make.present?

          vehicle_make_type = VehicleMakeType.where(vehicle_type_id: vehicle_type.id, vehicle_make_id: vehicle_make.id).first
          error!("Vehicle model of this type or make not found." , 404) unless vehicle_make_type.present?

          vehicle_model = VehicleModel.find_by(id: params[:vehicle][:vehicle_model_id])
          error!("Vehicle model not found." , 404) unless vehicle_model.present?

          driver = Driver.new(driver_params)
          vehicle = Vehicle.new(vehicle_params)

          vehicle.assign_attributes(vehicle_type: vehicle_type, vehicle_make: vehicle_make, vehicle_model: vehicle_model, driver: driver)

          if driver.valid? & vehicle.valid? && driver.save
            UserMailer.delay(:queue => 'mailers').driver_account_creation_mail(driver)

            {
              message: 'Registration successful.',
              data: {
                'Auth-Token': driver.auth_token,
                full_name: driver.full_name,
                company: driver.company
              }
            }
          else
            message = []
            message << driver.errors.full_messages  if driver.errors.present?
            message << vehicle.errors.full_messages  if vehicle.errors.present?
            error!(message.join(', '), 400)
          end
        end
      end
    end
  end
end