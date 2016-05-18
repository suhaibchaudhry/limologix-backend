module V1
  module Drivers
    class PasswordsEndpoint < Root
      namespace :drivers do
        desc 'Verifies email and send reset password mail'
        params do
          requires :email, type: String, allow_blank: false
        end
        post 'reset_password' do
          driver = Driver.find_by(email: params[:email])

          if driver.present?
            driver.update_reset_password_token!
            success!("Email has been sent to registered email address")
          else
            error!('Email not found', 404)
          end
        end

        desc 'Creates new password by verifying password token'
        params do
          requires :password, type: String, allow_blank: false
          requires :reset_password_token, type: String, allow_blank: false
        end
        post 'update_password' do
          driver = Driver.find_by(reset_password_token: params[:reset_password_token])

          if driver.present? && !driver.password_token_expired?
            if driver.update(password: params[:password], reset_password_token: nil)
              success!("Password has been set successfully")
            else
              error!({ message: 'Validations failed', data: {
                driver: driver.errors.messages,
              }}, 403)
            end

          else
            error!('Password token is invalid or expired', 403)
          end
        end

        # desc 'Provides auth_token by verifying password token'
        # params do
        #   requires :reset_password_token, type: String, allow_blank: false
        # end
        # post 'update_password' do
        #   user = User.find_by(reset_password_token: params[:reset_password_token])
        #   if user.present? && !user.password_token_expired?
        #    user.update_auth_token!
        #                 success!("Login successfull", {
        #         auth_token: user.auth_token
        #       })
        #   else
        #     error_json(401, 'Password token is invalid or expired')
        #   end
        # end
      end
    end
  end
end