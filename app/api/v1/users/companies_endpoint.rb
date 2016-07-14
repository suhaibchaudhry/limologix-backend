module V1
  module Users
    class CompaniesEndpoint < Root
      authorize_routes!

      before do
        authenticate!
      end

      helpers do
        def company_params
          params[:company][:logo] = params[:company][:logo].present? ? decode_base64_image(params[:company][:logo][:name], params[:company][:logo][:image]) : nil
          params[:company][:address_attributes] = params[:company][:address]

          ActionController::Parameters.new(params).require(:company).permit(:name,
            :email, :primary_phone_number, :secondary_phone_number, :logo,
            address_attributes: [:street, :city, :zipcode, :state_code, :country_code] )
        end
      end

      namespace :users do
        namespace :companies do

          desc 'Companies list.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [
              { code: 200, message: { status: 'success', message: 'Companies list.',
                data: {
                  drivers: [{id: 1, first_name: 'Avinash', last_name: 'T', mobile_number: '78787878', email: 'avinash123@yopmail.com', status: 'pending'},
                    {id: 2, first_name: 'Avinash', last_name: 'T', mobile_number: '78787878', email: 'avinash123@yopmail.com', status: 'pending'}]
                  }
                }.to_json },
              { code: 201, message: { status: 'success', message: 'No results found.'}.to_json }]
          end
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index', authorize: [:index, CompaniesEndpoint] do
            companies = paginate(Company.all.order(:created_at).reverse_order)

            if companies.present?
              {
                message: 'Companies list.',
                data: {
                  companies: serialize_model_object(companies)
                }
              }
            else
              { message: 'No results found.'}
            end
          end

          desc 'Company details update.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Company details updated successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'company name is missing, company name is empty'
                }.to_json
              }]
          end
          params do
            requires :company, type: Hash do
              requires :name, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false
              optional :primary_phone_number, type: String

              optional :logo, type: Hash do
                optional :name, type: String
                optional :image, type: String
              end

              optional :secondary_phone_number, type: String

              optional :address, type: Hash do
                optional :street, type: String
                optional :city, type: String
                optional :zipcode, type: Integer
                optional :state_code, type: String
                optional :country_code, type: String
              end
            end
          end
          post 'update', authorize: [:update, CompaniesEndpoint] do
            company = current_user.company
            if company.update(company_params)
              { message: 'Company details updated successfully.'}
            else
              error!(company.errors.full_messages , 401)
            end
          end

          desc 'Get Company details.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }
            http_codes [ { code: 201, message:
              {
                status: 'success',
                message: 'Company details updated successfully.',
                data: {
                  company: {
                    id: 2,
                    name: 'dsad',
                    logo: {
                      name: 'image_1463402627.jpeg',
                      image: '/uploads/company/logo/1/image_1463402627.jpeg'
                    },
                    email: 'sadsad',
                    primary_phone_number: '1231231234',
                    secondary_phone_number: 'null',
                    address: {
                      street: 'LNP',
                      city: 'Guntur',
                      zipcode: 522004,
                      state: { code: 'AL', name: 'Albama' },
                      country: { code: 'US', name: 'United States' }
                    }
                  }
                }
              }.to_json },
              { code: 404, message: { status: 'error', message: 'Company not found.'}.to_json } ]
          end
          get 'show' do
            error!('Company not found.', 404) unless current_user.company
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