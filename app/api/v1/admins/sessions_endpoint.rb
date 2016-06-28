module V1
  module Admins
    class SessionsEndpoint < Root

      namespace :admins do
        desc 'Admin login' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Login successfull.', data: {'Auth-Token': 'HDGHSDGSD4454','email': "Avinash489@yopmail.com"} }.to_json },
            { code: 401, message: { status: 'error', message: 'Invalid credentails.' }.to_json }]
        end
        params do
          requires :email, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post 'sign_in' do
          admin = Admin.find_by(email: params[:email])

          if admin.present? && admin.verify_password?(params[:password])
            admin.update_auth_token!

            {
              message: 'Login successfull.',
              data: {
                'Auth-Token': admin.auth_token,
              }
            }
          else
            error!('Invalid credentails.', 401)
          end
        end

        desc 'Admin logout' do
          headers 'Auth-Token': { description: 'Validates your identity', required: true }

          http_codes [ { code: 201, message: { status: 'success', message: 'Logged out successfully.'}.to_json }]
        end
        get 'logout' do
          authenticate!
          current_admin.update(auth_token: nil)

          {
            message: 'Logged out successfully.',
          }
        end

      end
    end
  end
end