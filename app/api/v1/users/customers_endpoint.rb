module V1
  module Users
    class CustomersEndpoint < Root

      before do
        authenticate!
      end

      helpers do
        def customer_params
          ActionController::Parameters.new(params).require(:customer).permit(:first_name,
            :last_name, :email, :mobile_number)
        end
      end

      namespace :users do
        namespace :customers do
          desc 'Customer creation.' do
            http_codes [ { code: 201, message: { status: 'success', message: 'Customer created successfully.'}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Customer first name is missing, Customer last name is empty',
                }.to_json
              }]
          end
          params do
            requires :auth_token, type: String, allow_blank: false
            requires :customer, type: Hash do
              requires :first_name, type: String, allow_blank: false
              requires :last_name, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false
              requires :mobile_number, type: String, allow_blank: false
            end
          end
          post 'create' do
            customer  = Customer.new(customer_params)
            if customer.valid?
              customer.company = current_user.company
              customer.save
              { message: 'Customer created successfully.' }
            else
              error!(error_formatter(customer) , 401)
            end
          end

          desc 'Customers list' do
            http_codes [ { code: 201, message: { status: 'success', message: 'Customers list.',
              data: {
                customers: [ {"id":1,"first_name":"customer1","last_name":"t","email":"customer1","mobile_number":"customer1"},
                  {"id":2,"first_name":"customer1","last_name":"t","email":"customer1","mobile_number":"customer1"}]
              }
            }.to_json }]
          end
          params do
            requires :auth_token, type: String, allow_blank: false
          end
          post 'index' do
            {
              message: 'Customers list.',
              data: {
                customers: serialize_model_object(current_user.company.customers)
              }
            }
          end

        end
      end
    end
  end
end