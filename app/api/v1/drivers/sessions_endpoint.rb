module V1
  module Drivers
    class SessionsEndpoint < Root
      namespace :drivers do
        desc 'Driver login' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Login successfull.', data: {auth_token: 'HDGHSDGSD4454'} }.to_json },
            { code: 401, message: { status: 'error', message: 'Invalid credentails.' }.to_json }]
        end
        params do
          requires :user_name, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post 'sign_in' do
          driver = Driver.find_by(username: params[:username])
           if driver.present? && driver.verify_password?(params[:password])
            driver.update_auth_token!
            success!("Login successfull", {
                auth_token: driver.auth_token
              })
           else
            error!('Invalid credentails', 401)
           end
        end

        desc 'Driver logout' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Logged out successfully.'}.to_json }]
        end
        params do
          requires :auth_token, type: String, allow_blank: false
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