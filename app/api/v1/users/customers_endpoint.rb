module V1
  module Users
    class CustomersEndpoint < Root

      before do
        authenticate!
      end

      helpers do
        def customer_params
          ActionController::Parameters.new(params).require(:customer).permit(:first_name,
            :last_name, :email, :mobile_number, :organisation)
        end
      end

      namespace :users do
        namespace :customers do
          desc 'Customer creation.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Customer created successfully.', data:
              {customer: {id: 1, first_name: "customer1", last_name: "t", email:"customer1", mobile_number:"customer1sad", organisation: "sa dasd"}}}.to_json },
              { code: 401,
                message: {
                  status: 'error',
                  message: 'Customer first name is missing, Customer last name is empty',
                }.to_json
              }]
          end
          params do
            requires :customer, type: Hash do
              requires :first_name, type: String, allow_blank: false
              requires :last_name, type: String, allow_blank: false
              requires :email, type: String, allow_blank: false
              requires :mobile_number, type: String, allow_blank: false
              requires :organisation, type: String, allow_blank: false
            end
          end
          post 'create' do
            customer  = current_user.customers.new(customer_params)

            if customer.save
              {
                message: 'Customer created successfully.',
                data:{
                  customer: serialize_model_object(customer)
                }
               }
            else
              error!(error_formatter(customer) , 401)
            end
          end

          desc 'Customers list' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [
              { code: 201, message: { status: 'success', message: 'Customers list.',
                data: {
                  customers: [ {'id':1,'first_name':'customer1','last_name':'t','email':'customer1','mobile_number':'customer1sad','organisation':'null'},
                    {'id':2,'first_name':'customer1','last_name':'t','email':'customer1','mobile_number':'customer1sad','organisation':'null'}]
                  }
                }.to_json },
              { code: 201, message: { status: 'success', message: 'No results found.'}.to_json }
            ]
          end
          get 'index' do
            {
              message: 'Customers list.',
              data: {
                customers: serialize_model_object(current_user.company.customers)
              }
            }
          end

          desc 'Customers search' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [
              { code: 201, message: { status: 'success', message: 'Customers list.',
                data: {
                  customers: [ {'id':1,'first_name':'customer1','last_name':'t','email':'customer1','mobile_number':'customer1sad','organisation':'null'},
                    {'id':2,'first_name':'customer1','last_name':'t','email':'customer1','mobile_number':'customer1sad','organisation':'null'}]
                  }
                }.to_json },
              { code: 201, message: { status: 'success', message: 'No results found.'}.to_json }
            ]
          end
          params do
            requires :search_string, type: String
          end
          post 'search' do
            customers = serialize_model_object(current_user.company.customers.where("CONCAT(customers.first_name,' ', customers.last_name) like ? ", "#{params[:search_string]}%"))

            if customers.present?
              {
                message: 'Customers list.',
                data: {
                  customers: customers
                }
              }
            else
              { message: 'No results found.'}
            end
          end

        end
      end
    end
  end
end