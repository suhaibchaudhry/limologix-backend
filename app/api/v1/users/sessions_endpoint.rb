module V1
  module Users
    class SessionsEndpoint < Root
      namespace :users do
        desc 'Admin login' do
          detail 'success => {status: "success", message: "Login successfull", data: {auth_token: "HDGHSDGSD4454"}},
          failure => { message: Invalid credentails"}'
        end
        params do
          requires :user_name, type: String, allow_blank: false
          requires :password, type: String, allow_blank: false
        end
        post 'sign_in' do
          user = User.find_by(user_name: params[:user_name])
           if user.present? && user.verify_password?(params[:password])
            user.update_auth_token
            success_json("Login successfull", {
                auth_token: user.auth_token
              })
            {
              status: "success",
              data: {
                auth_token: user.auth_token
              },
              message: "Login successfull"
            }
           else
            error_json(401, 'Invalid credentails')
           end
        end
      end
    end
  end
end