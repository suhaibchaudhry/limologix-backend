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
          desc 'Customer creation.'
          params do
            requires :customer, type: Hash do
              requires :first_name, type: String, allow_blank: false
              requires :last_name, type: String, allow_blank: false
              optional :email, type: String
              optional :mobile_number, type: String
              optional :organisation, type: String
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
              error!(customer.errors.full_messages , 401)
            end
          end

          desc 'Customers list'
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index' do
            customers = paginate(current_user.company.customers.order(:created_at).reverse_order)

            if customers.present?
              {
                message: 'Customers list.',
                data: {
                  customers: serialize_model_object(customers)
                }
              }
            else
              { message: 'No results found.'}
            end
          end

          desc 'Customers search'
          params do
            requires :search_string, type: String
          end
          post 'search' do
            customers = current_user.company.customers.where("CONCAT(customers.first_name,' ', customers.last_name) like ? ", "#{params[:search_string]}%")

            if customers.present?
              {
                message: 'Customers list.',
                data: {
                  customers: serialize_model_object(customers)
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