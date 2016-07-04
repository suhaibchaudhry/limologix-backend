module V1
  module Users
    class RegistrationsEndpoint < Root

      helpers do
        def user_params
          ActionController::Parameters.new(params).require(:user).permit(:first_name, :last_name, :password, :email)
        end

        def company_params
          ActionController::Parameters.new(params).require(:company).permit(:name, :email)
        end
      end

      namespace :users do
        desc 'Company registration.' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Registration successfull.', data: {'Auth-Token': 'HDGHSDGSD4454','full_name': "Avinash T", 'role': 'super_admin'} }.to_json },
            { code: 401,
              message: {
                status: 'error',
                message: 'User email has already been taken, Company email has already been taken'
              }.to_json
            }
          ]
        end
        params do
          requires :user, type: Hash do
            requires :first_name, type: String, allow_blank: false
            requires :last_name, type: String, allow_blank: false
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
          company = Company.new(company_params)

          if user.valid? & company.valid?
            user.role = Role.admin
            user.company = company
            user.save

            {
              message: 'Registration successfull.',
              data: {
                'Auth-Token': user.auth_token,
                full_name: user.full_name,
                role: user.role.name
              }
            }
          else
            message = error_formatter(user) + ", " + error_formatter(company)
            error!(message , 401)
          end
        end
      end
    end
  end
end