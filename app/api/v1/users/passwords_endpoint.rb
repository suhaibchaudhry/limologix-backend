module V1
  module Users
    class PasswordsEndpoint < Root
      namespace :users do
        desc 'Verifies email and send reset password mail' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Email has been sent to registered email address.' }.to_json },
            { code: 401, message: { status: 'error', message: 'Email not found.' }.to_json }]
        end
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

        desc 'Creates new password by verifying password token' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Password has been set successfully.', data: {auth_token: 'HDGHSDGSD4454'} }.to_json },
            { code: 401,
              message: {
                status: 'error',
                message: 'User password is empty'
              }.to_json
            }]
        end
        params do
          requires :user, type: Hash do
            requires :password, type: String, allow_blank: false
            requires :reset_password_token, type: String, allow_blank: false
          end
        end
        post 'reset_password' do
          user = User.find_by(reset_password_token: params[:user][:reset_password_token])

          if user.present? && !user.password_token_expired?
            if user.update(password: params[:user][:password], reset_password_token: nil)
              { message: 'Password has been set successfully.' }
            else
              error!(error_formatter(user) , 401)
            end

          else
            error!('Password token is invalid or expired', 401)
          end
        end
      end
    end
  end
end