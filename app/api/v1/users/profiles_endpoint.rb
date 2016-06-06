module V1
  module Users
    class ProfilesEndpoint < Root
      before do
        authenticate!
      end

      helpers do
        def user_params
          ActionController::Parameters.new(params).require(:user).permit(:first_name, :last_name, :email, :mobile_number )
        end
      end

      namespace :users do
        namespace :profile do

          desc 'Update profile details.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Profile details updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'User first name is missing, User last name is empty'
                }.to_json
              }]
          end
          params do
            requires :user, type: Hash do
              requires :first_name, type: String, allow_blank: false
              requires :last_name, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false
              optional :mobile_number, type: String, allow_blank: false
            end
          end
          post 'update' do
            user = current_user

            if user.update(user_params)
              { message: 'Profile details updated successfully.'}
            else
              error!(error_formatter(user) , 401)
            end
          end

          desc 'Get User profile details.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: {"status":"success","message":"User profile details.",
              "data":{"user":{"first_name":"Surya","last_name":"T","email":"surya12345@yopmail.com","mobile_number":"1231231234"}}}.to_json }]
          end
          get 'show' do
            {
              message: 'User profile details.',
              data: {
                user: serialize_model_object(current_user)
              }
            }
          end

          desc 'Update username or password' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Password has been updated successfully.'}.to_json },
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
            end
          end
          post 'reset_authentication_details' do
            user = current_user

            if user.update(password: params[:user][:password], auth_token: nil)
              { message: 'Password has been updated successfully.'}
            else
              error!(error_formatter(user) , 401)
            end
          end

        end
      end
    end
  end
end