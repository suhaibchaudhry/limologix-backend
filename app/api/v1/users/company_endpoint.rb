module V1
  module Users
    class CompanyEndpoint < Root
      after_validation do
        authenticate!
      end

      helpers do
        def company_params
          params[:company][:logo] = ActionDispatch::Http::UploadedFile.new(params[:company][:logo]) if params[:company][:logo]
          ActionController::Parameters.new(params).require(:company).permit(:name,
            :email, :primary_phone_number, :secondary_phone_number, :fax, :logo,
            address_attributes: [:street, :city, :zipcode, :state_code, :country_code] )
        end
      end

      namespace :users do
        namespace :company do

          desc 'Company details update.' do
            http_codes [ { code: 201, message: { status: 'success', message: 'Company details updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Validations failed.',
                  data: {
                    company: {
                      logo: [
                        'not valid'
                      ]
                    }
                  }
                }.to_json
              }]
          end
          params do
            requires :auth_token, type: String, allow_blank: false
            requires :company, type: Hash do
              requires :name, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false
              optional :primary_phone_number, type: String, allow_blank: false
              optional :logo, type: Rack::Multipart::UploadedFile, allow_blank: false

              optional :secondary_phone_number, type: String, allow_blank: false
              optional :fax, type: String, allow_blank: false

              optional :address_attributes, type: Hash do
                optional :street, type: String, allow_blank: false
                optional :city, type: String, allow_blank: false
                optional :zipcode, type: Integer, allow_blank: false
                optional :state_code, type: String, allow_blank: false
                optional :country_code, type: String, allow_blank: false
              end
            end
          end
          post 'update' do
            if current_user.limo_company.update(company_params)
              { message: 'Company details updated successfully.'}
            else
              error!({ message: 'Validations failed.', data:{
                company: company.errors.messages
                }}, 401)
            end
          end

        end
      end

    end
  end
end