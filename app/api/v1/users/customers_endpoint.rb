module V1
  module Users
    class CustomersEndpoint < Root

      after_validation do
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
                  message: 'Validations failed.',
                  data: {
                    customer: {
                      email: [
                        'is invalid.'
                      ]
                    }
                  }
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
              customer.save
              { message: 'Customer created successfully.' }
            else
              error!({ message: 'Validations failed.', data:{
                customer: customer.errors.messages,
              }}, 401)
            end
          end

          desc 'Customers list' do
            http_codes [ { code: 201, message: { status: 'success', message: 'Customer list.', data: {auth_token: 'HDGHSDGSD4454'} }.to_json }]
          end
          params do
            requires :auth_token, type: String, allow_blank: false
          end
          post 'index' do
            {
              message: 'Customer created successfully.',
              data: {
                customer: serialize_model_object(Customer.all)
              }
            }
          end

        end
      end
    end
  end
end