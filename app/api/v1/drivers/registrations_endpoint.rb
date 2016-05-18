module V1
  module Drivers
    class RegistrationsEndpoint < Root
      helpers do
        def driver_params
          ActionController::Parameters.new(params).require(:driver).permit(:first_name, :last_name, :user_name, :password, :email, :mobile_number, :home_phone_number )
        end
      end

      namespace :drivers do
        desc 'Creates a driver account' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Registration successfull.', data: {auth_token: 'HDGHSDGSD4454'} }.to_json },
            { code: 401,
              message: {
                status: 'error',
                message: 'Driver first name has already been taken'
              }.to_json
            }
          ]
        end
        params do
          requires :driver, type: Hash do
            requires :first_name, type: String, allow_blank: false
            requires :last_name, type: String, allow_blank: false
            requires :username, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
            requires :mobile_number, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
            requires :home_phone_number, type: String, allow_blank: false
          end
        end
        post 'sign_up' do
          driver = Driver.new(driver_params)

          if driver.save
            success!("Registration successfull", {
              auth_token: driver.auth_token
            })
          else
            error!(error_formatter(driver) , 401)
          end
        end
      end
    end
  end
end