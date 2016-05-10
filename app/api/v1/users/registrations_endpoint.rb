module V1
  module Users
    class RegistrationsEndpoint < Root
      helpers do
        def user_params
          ActionController::Parameters.new(params).require(:user).permit(:user_name, :password, :email)
        end

        def company_params
          ActionController::Parameters.new(params).require(:company).permit(:name, :email)
        end
      end

      namespace :users do
        desc 'Company registration.' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Registration successfull.', data: {auth_token: 'HDGHSDGSD4454'} }.to_json },
            { code: 401,
              message: {
                status: 'error',
                message: 'Validations failed.',
                data: {
                  user: {
                    user_name: [
                      'has already been taken'
                    ]
                  },
                  company: {
                    email: [
                      'has already been taken'
                    ]
                  }
                }
              }.to_json
            }
          ]
        end
        params do
          requires :user, type: Hash do
            requires :user_name, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
          end

          requires :company, type: Hash do
            requires :name, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
          end
        end
        post 'registration' do
          user = User.new(user_params)
          company = LimoCompany.new(company_params)

          if user.valid? & company.valid?
            user.role = Role.admin
            user.limo_company = company
            user.save

            {
              message: 'Registration successfull.',
              data: {
                auth_token: user.auth_token
              }
            }
          else
            error!({ message: 'Validations failed.', data:{
              user: user.errors.messages,
              company: company.errors.messages
            }}, 401)
          end
        end

        desc 'Verify\'s whether user_name exists in system' do
          http_codes [ { code: 201, message: { status: 'success', message: 'User name is unique.' }.to_json },
            { code: 401, message: { status: 'error', message: 'User name already exists.' }.to_json }]
        end
        params do
          requires :user_name, type: String, allow_blank: false
        end
        post 'verify_user_name' do
          user = User.find_by(user_name: params[:user_name])
          unless user.present?
            { message: 'User name is unique.' }
          else
            error!('User name already exists.', 401)
          end
        end

      end
    end
  end
end