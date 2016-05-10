module V1
  module Users
    class SessionsEndpoint < Root

      namespace :users do
        desc 'User login' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Login successfull', data: {auth_token: 'HDGHSDGSD4454'} }.to_json },
            { code: 401, message: { status: 'error', message: 'Invalid credentails' }.to_json }]
        end
        params do
          requires :user_name, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post 'sign_in' do
          user = User.find_by(user_name: params[:user_name])
           if user.present? && user.verify_password?(params[:password])
            user.update_auth_token!
            {
              message: 'Login successfull.',
              data: {
                auth_token: user.auth_token
              }
            }
           else
            error!('Invalid credentails.', 401)
           end
        end

        desc 'User logout' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Logged out successfully.'}.to_json }]
        end
        params do
          requires :auth_token, type: String, allow_blank: false
        end
        post 'logout' do
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