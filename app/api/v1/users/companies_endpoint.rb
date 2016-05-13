module V1
  module Users
    class CompaniesEndpoint < Root
      before do
        authenticate!
      end

      helpers do
        def company_params
          params[:company][:logo] = ActionDispatch::Http::UploadedFile.new(params[:company][:logo]) if params[:company][:logo]
          params[:company][:address_attributes] = params[:company][:address]
          ActionController::Parameters.new(params).require(:company).permit(:name,
            :email, :primary_phone_number, :secondary_phone_number, :fax, :logo,
            address_attributes: [:street, :city, :zipcode, :state_code, :country_code] )
        end
      end

      namespace :users do
        namespace :companies do

          desc 'Company details update.' do
            http_codes [ { code: 201, message: { status: 'success', message: 'Company details updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'company name is missing, company name is empty'
                }.to_json
              }]
          end
          params do
            requires :auth_token, type: String, allow_blank: false
            requires :company, type: Hash do
              requires :name, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false
              optional :primary_phone_number, type: String
              optional :logo, type: Rack::Multipart::UploadedFile

              optional :secondary_phone_number, type: String
              optional :fax, type: String

              optional :address, type: Hash do
                optional :street, type: String
                optional :city, type: String
                optional :zipcode, type: Integer
                optional :state_code, type: String
                optional :country_code, type: String
              end
            end
          end
          post 'update' do
            company = current_user.company
            if company.update(company_params)
              { message: 'Company details updated successfully.'}
            else
              error!(error_formatter(company) , 401)
            end
          end

          desc 'Get Company details.' do
            http_codes [ { code: 201, message:
              {
                status: "success",
                message: "Company details updated successfully.",
                data: {
                  company: {
                    id: 2,
                    name: "dsad",
                    logo: "/uploads/company/logo/2/certficate3.jpg",
                    email: "sadsad",
                    primary_phone_number: "1231231234",
                    secondary_phone_number: "null",
                    fax: "null",
                    address: {
                      street: "LNP",
                      city: "Guntur",
                      zipcode: 522004,
                      state: "Alaska",
                      country: "United States"
                    }
                  }
                }
              }.to_json },
              { code: 404, message: { status: 'error', message: 'Company not found.'}.to_json } ]
          end
          params do
            requires :auth_token, type: String, allow_blank: false
          end
          post 'show' do
            error!({ message: 'Company not found.'}, 404) unless current_user.company
            {
              message: 'Company details.',
              data: {
                company: serialize_model_object(current_user.company)
              }
            }
          end

        end
      end

    end
  end
end