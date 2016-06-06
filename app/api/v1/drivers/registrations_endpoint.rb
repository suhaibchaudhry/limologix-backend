module V1
  module Drivers
    class RegistrationsEndpoint < Root
      helpers do
        def driver_params
          ActionController::Parameters.new(params).require(:driver).permit(:first_name, :last_name,
            :password, :email, :mobile_number, :home_phone_number, :company)
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
            optional :home_phone_number, type: String
            optional :company, type: String
          end
        end
        post 'registration' do
          driver = Driver.new(driver_params)

          if driver.save
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