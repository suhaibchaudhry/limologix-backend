module V1
  module Users
    class WebNotificationsEndpoint < Root
      before do
        authenticate!
      end

      namespace :users do
        namespace :notifications do

          desc 'List of notifications.'
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index', each_serializer: GroupsArraySerializer do
            notifications = paginate(current_user.company.web_notifications.order(:created_at).reverse_order)

            if notifications.present?
              {
                message: 'Notifications list.',
                data: {
                  groups: serialize_model_object(notifications)
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