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

          desc 'Update profile details.'
          params do
            requires :user, type: Hash do
              requires :first_name, type: String, allow_blank: false
              requires :last_name, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false
              optional :mobile_number, type: String, allow_blank: false
            end
          end
          post 'update' do
            if current_user.update(user_params)
              { message: 'Profile details updated successfully.'}
            else
              error!(current_user.errors.full_messages , 400)
            end
          end

          desc 'Get User profile details.'
          get 'show' do
            {
              message: 'User profile details.',
              data: {
                user: serialize_model_object(current_user)
              }
            }
          end

          desc 'Update password'
          params do
            requires :user, type: Hash do
              requires :password, type: String, allow_blank: false
            end
          end
          post 'reset_authentication_details' do
            if current_user.update(password: params[:user][:password], auth_token: nil)
              { message: 'Password has been updated successfully.'}
            else
              error!(current_user.errors.full_messages , 400)
            end
          end
        end
      end
    end
  end
end