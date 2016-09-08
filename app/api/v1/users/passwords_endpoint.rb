module V1
  module Users
    class PasswordsEndpoint < Root
      namespace :users do
        desc 'Verifies email and send reset password mail'
        params do
          requires :email, type: String, allow_blank: false
        end
        post 'forgot_password' do
          user = User.find_by(email: params[:email])

          if user.present? && user.update_reset_password_token!
            UserMailer.reset_password_mail(user).deliver_now
            { message: 'Email has been sent to registered email address.' }
          else
            error!('Email not found.', 404)
          end
        end

        desc 'Creates new password by verifying password token'
        params do
          requires :user, type: Hash do
            requires :password, type: String, allow_blank: false
            requires :reset_password_token, type: String, allow_blank: false
            requires :user_type, type: String, allow_blank: false
          end
        end
        post 'reset_password' do
          user = params[:user][:user_type].titleize.constantize.find_by(reset_password_token: params[:user][:reset_password_token])

          if user.present? && !user.password_token_expired?
            if user.update(password: params[:user][:password], reset_password_token: nil)
              { message: 'Password has been set successfully.', type: params[:user][:user_type].titleize }
            else
              error!(user.errors.full_messages , 401)
            end

          else
            error!('Password token is invalid or expired.', 401)
          end
        end
      end
    end
  end
end