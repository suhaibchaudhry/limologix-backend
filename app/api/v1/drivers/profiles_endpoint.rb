module V1
  module Drivers
    class ProfilesEndpoint < Root
      helpers do
        def driver_params
          ActionController::Parameters.new(params).require(:driver).permit(:first_name, :last_name, :mobile_number, :email, :dob, :home_phone_number, :fax_number, 
            :social_security_number, :display_name, :license_number, :license_image, :license_expiry_date, :badge_number
            :badge_expiry_date, :ara_number, :ara_image, :ara_exp_date,)
        end
      end

      namespace :drivers do
        namespace :profile do
          desc 'Update profile details.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }
            http_codes [ { code: 201, message: { status: 'success', message: 'Profile updated successfully.'}.to_json },
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
              optional :dob, type: Date
              optional :home_phone_number, type: String
              optional :fax_number, type: String
              optional :social_security_number, type: String
              optional :display_name, type: String
              optional :license_number, type: String
              optional :license_image, type: String
              optional :license_expiry_date, type: Date
              optional :badge_number, type: String
              optional :badge_expiry_date, type: Date
              optional :ara_number, type: String
              optional :ara_image, type: String
              optional :ara_exp_date, type: Date
            end
          end
          post 'update' do
            if current_driver.update(driver_params)
              { message: 'Profile details updated successfully.'}
            else
              error!(error_formatter(current_driver) , 401)
            end
          end
        end
      end
    end
  end
end