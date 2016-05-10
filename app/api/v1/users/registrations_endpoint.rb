module V1
  module Users
    class RegistrationsEndpoint < Root
      helpers do
        def user_params
          ActionController::Parameters.new(params).require(:user).permit(:first_name, :last_name, :user_name, :password, :email, :mobile_number )
        end

        def company_params
          params[:company][:logo] = ActionDispatch::Http::UploadedFile.new(params[:company][:logo]) if params[:company][:logo]
          ActionController::Parameters.new(params).require(:company).permit(:uid, :name,
            :email, :primary_phone_number, :secondary_phone_number, :fax, :logo,
            address_attributes: [:street, :city, :zipcode, :state_code, :country_code] )
        end
      end

      namespace :users do
        desc 'Creates an admin account with company details' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Registration successfull', data: {auth_token: 'HDGHSDGSD4454'} }.to_json },
            { code: 401,
              message: {
                status: 'error',
                message: 'Validations failed',
                data: {
                  user: {
                    user_name: [
                      'has already been taken'
                    ],
                    mobile_number: [
                      'has already been taken'
                    ]
                  },
                  company: {
                    email: [
                      'has already been taken'
                    ],
                    uid: [
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
            requires :first_name, type: String, allow_blank: false
            requires :last_name, type: String, allow_blank: false
            requires :user_name, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
            requires :mobile_number, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
          end

          requires :company, type: Hash do
            requires :uid, type: String, allow_blank: false
            requires :name, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
            requires :primary_phone_number, type: String, allow_blank: false
            optional :logo, type: Rack::Multipart::UploadedFile, allow_blank: false

            optional :secondary_phone_number, type: String, allow_blank: false
            optional :fax, type: String, allow_blank: false

            requires :address_attributes, type: Hash do
              requires :street, type: String, allow_blank: false
              requires :city, type: String, allow_blank: false
              requires :zipcode, type: Integer, allow_blank: false
              requires :state_code, type: String, allow_blank: false
              requires :country_code, type: String, allow_blank: false
            end
          end
        end
        post 'sign_up' do
          user = User.new(user_params)
          company = LimoCompany.new(company_params)

          if user.valid? & company.valid?
            user.role = Role.find_by_name('admin')
            user.limo_company = company
            user.save
            {
              message: 'Registration successfull',
              data: {
                auth_token: user.auth_token
              }
            }
          else
            error!({ message: 'Validations failed', data:{
              user: user.errors.messages,
              company: company.errors.messages
            }}, 401)
          end
        end

        desc 'Verify\'s whether user_name exists in system' do
          http_codes [ { code: 201, message: { status: 'success', message: 'User name already exists' }.to_json }]
        end
        params do
          requires :user_name, type: String, allow_blank: false
        end
        post 'verify_user_name' do
          user = User.find_by(user_name: params[:user_name])
          unless user.present?
            { message: 'User name is unique' }
          else
            error!('User name already exists', 401)
          end
        end

        desc 'Creates a manager' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Manager account created successfully' }.to_json },
            { code: 401,
              message: {
                status: 'error',
                message: 'Validations failed',
                data: {
                  user: {
                    user_name: [
                      'has already been taken'
                    ],
                    mobile_number: [
                      'has already been taken'
                    ]
                  }
                }
              }.to_json
            }
          ]
        end
        params do
          requires :auth_token, type: String, allow_blank: false
          requires :user, type: Hash do
            requires :first_name, type: String, allow_blank: false
            requires :last_name, type: String, allow_blank: false
            requires :user_name, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
            requires :mobile_number, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
          end
        end
        post'create_manager' do
          authenticate!
          user = User.new(user_params)
          if user.valid?
            user.role = Role.find_by_name('manager')
            user.admin = current_user
            user.save
            { message: 'Manager account created successfully' }
          else
            error!({ message: 'Validations failed', data: {
              user: user.errors.messages,
            }}, 401)
          end
        end

      end
    end
  end
end