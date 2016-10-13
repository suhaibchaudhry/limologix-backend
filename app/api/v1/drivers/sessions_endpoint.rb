module V1
  module Drivers
    class SessionsEndpoint < Root
      namespace :drivers do
        desc 'Driver login'
        params do
          requires :email, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post 'sign_in' do
          driver = Driver.find_by(email: params[:email])
           if driver.present? && driver.verify_password?(params[:password])
            driver.update_auth_token!

            {
              message: 'Login successful.',
              data: {
                'Auth-Token': driver.auth_token,
                full_name: driver.full_name,
                first_name: driver.first_name,
                last_name: driver.last_name,
                company: driver.company
              }
            }
           else
            error!('Invalid credentials', 401)
           end
        end

        desc 'Driver logout'
        get 'logout' do
          authenticate!
          puts "removing this driver from redis"
          $redis.call [:hdel, "drivers", current_driver.merchant_id]
          puts "removed this driver from redis"
          current_driver.update(auth_token: nil)
          {
            message: 'Logged out successfully.',
          }
        end
      end
    end
  end
end