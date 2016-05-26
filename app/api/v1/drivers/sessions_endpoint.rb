module V1
  module Drivers
    class SessionsEndpoint < Root
      namespace :drivers do
        desc 'Driver login' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Login successfull.', data: {'Auth-Token': 'HDGHSDGSD4454'} }.to_json },
            { code: 401, message: { status: 'error', message: 'Invalid credentails.' }.to_json }]
        end
        params do
          requires :username, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post 'sign_in' do
          driver = Driver.find_by(username: params[:username])
           if driver.present? && driver.verify_password?(params[:password])
            driver.update_auth_token!

            {
              message: 'Login successfull.',
              data: {
                'Auth-Token': driver.auth_token
              }
            }
           else
            error!('Invalid credentails', 401)
           end
        end

        desc 'Driver logout' do
          headers 'Auth-Token': { description: 'Validates your identity', required: true }

          http_codes [ { code: 201, message: { status: 'success', message: 'Logged out successfully.'}.to_json }]
        end
        post 'logout' do
          authenticate!
          current_driver.update(auth_token: nil)
          {
            message: 'Logged out successfully.',
          }
        end
      end
    end
  end
end