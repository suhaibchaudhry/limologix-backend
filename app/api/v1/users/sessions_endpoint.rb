module V1
  module Users
    class SessionsEndpoint < Root

      namespace :users do
        desc 'User login'
        params do
          requires :email, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post 'sign_in' do
          user = User.find_by(email: params[:email])

          if user.present? && user.verify_password?(params[:password])
            user.update_auth_token!

            {
              message: 'Login successfull.',
              data: {
                'Auth-Token': user.auth_token,
                full_name: user.full_name,
                role: user.role.name
              }
            }
          else
            error!('Invalid credentials.', 401)
          end
        end

        desc 'User logout'
        get 'logout' do
          authenticate!
          current_user.update(auth_token: nil)

          {
            message: 'Logged out successfully.',
          }
        end

      end
    end
  end
end