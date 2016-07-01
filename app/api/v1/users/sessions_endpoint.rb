module V1
  module Users
    class SessionsEndpoint < Root

      namespace :users do
        desc 'User login' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Login successfull.', data: {'Auth-Token': 'HDGHSDGSD4454','email': "Avinash489@yopmail.com"} }.to_json },
            { code: 401, message: { status: 'error', message: 'Invalid credentails.' }.to_json }]
        end
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
            error!('Invalid credentails.', 401)
          end
        end

        desc 'User logout' do
          headers 'Auth-Token': { description: 'Validates your identity', required: true }

          http_codes [ { code: 201, message: { status: 'success', message: 'Logged out successfully.'}.to_json }]
        end
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