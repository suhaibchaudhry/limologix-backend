module V1
  module Users
    class SessionsEndpoint < Root
      namespace :users do
        desc 'Creates an admin account with company details'
        params do
          requires :user_name, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post 'sign_in' do
          user = User.find_by(user_name: params[:user_name])
           if user.present? && user.verify_password?(params[:password])
            user.update_auth_token
            {
              status: "success",
              data: {
                auth_token: user.auth_token
              },
              message: "Login successfull"
            }
           else
            error!({ message: 'Invalid credentails'}, 401)
           end
        end
      end
    end
  end
end