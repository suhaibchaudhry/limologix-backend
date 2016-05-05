module V1
  module Users
    class PasswordsEndpoint < Root
      namespace :users do
        desc 'Verifies email and send reset password mail'
        params do
          requires :email, type: String, allow_blank: false
        end
        post 'reset_password' do
          user = User.find_by(email: params[:email])

          if user.present?
            user.update_reset_password_token!
            success_json("Email has been sent to registered email address")
          else
            error_json(401, 'Email not found')
          end
        end

        desc 'Creates new password by verifying password token'
        params do
          requires :password, type: String, allow_blank: false
          requires :reset_password_token, type: String, allow_blank: false
        end
        post 'update_password' do
          user = User.find_by(reset_password_token: params[:reset_password_token])

          if user.present? && !user.password_token_expired?
            user.update(password: params[:password], reset_password_token: nil)
            success_json("Password has been set successfully")
          else
            error_json(401, 'Password token is invalid or expired')
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
        #     success_json("Login successfull", {
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