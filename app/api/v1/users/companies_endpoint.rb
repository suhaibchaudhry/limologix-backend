module V1
  module Users
    class CompaniesEndpoint < Root
      before do
        authenticate!
      end

      helpers do
        def company_params
          params[:company][:logo] = params[:company][:logo].present? ? parse_image_data(params[:company][:logo][:name], params[:company][:logo][:image]) : nil
          params[:company][:address_attributes] = params[:company][:address]

          ActionController::Parameters.new(params).require(:company).permit(:name,
            :email, :primary_phone_number, :secondary_phone_number, :fax, :logo,
            address_attributes: [:street, :city, :zipcode, :state_code, :country_code] )
        end

        def parse_image_data(filename, base64_image)
          in_content_type, encoding, string = base64_image.split(/[:;,]/)[1..3]
          # filename = filename.split(".")[0]

          tempfile = Tempfile.new(filename)
          tempfile.binmode
          tempfile.write Base64.decode64(string)

          # for security we want the actual content type, not just what was passed in
          content_type = `file --mime -b #{tempfile.path}`.split(";")[0]

          # we will also add the extension ourselves based on the above
          # if it's not gif/jpeg/png, it will fail the validation in the upload model
          # extension = content_type.match(/gif|jpeg|png|jpg/).to_s
          # filename += ".#{extension}" if extension

          ActionDispatch::Http::UploadedFile.new({
            tempfile: tempfile,
            content_type: content_type,
            filename: filename
          })
        end
      end

      namespace :users do
        namespace :companies do

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
            headers 'Auth-Token': { description: 'Validates your identity', required: true }
            http_codes [ { code: 201, message:
              {
                status: "success",
                message: "Company details updated successfully.",
                data: {
                  company: {
                    id: 2,
                    name: "dsad",
                    logo: {
                      name: "image_1463402627.jpeg",
                      image: "/uploads/company/logo/1/image_1463402627.jpeg"
                    },
                    email: "sadsad",
                    primary_phone_number: "1231231234",
                    secondary_phone_number: "null",
                    fax: "null",
                    address: {
                      street: "LNP",
                      city: "Guntur",
                      zipcode: 522004,
                      state: { code: "AL", name: "Albama" },
                      country: { code: "US", name: "United States" }
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