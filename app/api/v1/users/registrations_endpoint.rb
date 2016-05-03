module V1
  module Users
    class RegistrationsEndpoint < Root
      helpers do
        def user_params
          ActionController::Parameters.new(params).require(:user).permit(:first_name, :last_name, :user_name, :password, :mobile_number )
        end

        def company_params
          params[:company][:logo] = ActionDispatch::Http::UploadedFile.new(params[:company][:logo])
          ActionController::Parameters.new(params).require(:company).permit(:uid, :name,
            :email, :primary_phone_number, :secondary_phone_number, :fax, :logo,
            address: [:street, :city, :zipcode, :state_id, :country_id] )
        end
      end

      namespace :users do
        desc 'Creates an admin account with company details' do
          detail 'success {status: "success", message: "Registration successfull", data: {auth_token: "HDGHSDGSD4454"}},n
          failure { message: "Validations failed", user: "" }'
        end
        params do
          requires :user, type: Hash do
            requires :first_name, type: String, allow_blank: false
            requires :last_name, type: String, allow_blank: false
            requires :user_name, type: String, allow_blank: false
            requires :password, type: String, allow_blank: false
            requires :mobile_number, type: String, allow_blank: false
          end
          requires :company, type: Hash do
            requires :uid, type: String, allow_blank: false
            requires :name, type: String, allow_blank: false
            requires :email, type: String, allow_blank: false
            requires :primary_phone_number, type: String, allow_blank: false
            optional :secondary_phone_number, type: String, allow_blank: false
            optional :fax, type: String, allow_blank: false
            requires :logo, type: Rack::Multipart::UploadedFile, allow_blank: false
            requires :address_attributes, type: Hash do
              requires :street, type: String, allow_blank: false
              requires :city, type: String, allow_blank: false
              requires :zipcode, type: Integer, allow_blank: false
              requires :state_id, type: Integer, allow_blank: false
              requires :country_id, type: Integer, allow_blank: false
            end
          end
        end
        post 'registration' do
          user = User.new(user_params)
          company = LimoCompany.new(company_params)
          # byebug
          if user.valid? && company.valid?
            user.limo_company = company
            company.save
            user.save
            {
              status: "success",
              message: "Registration successfull",
              data: {
                auth_token: user.auth_token
              }
            }
          else
            error!({ message: 'Validations failed', data: {
              user: user.errors.messages,
              company: company.errors.messages
              }}, 401)
          end
        end
      end
    end
  end
end