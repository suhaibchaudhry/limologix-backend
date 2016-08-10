module V1
  module Users
    class WebNotificationsEndpoint < Root
      before do
        authenticate!
      end

      namespace :users do
        namespace :notifications do

          desc 'List of notifications.'
          params do
            requires :read_status, type: Boolean, allow_blank: false
          end
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index' do
            notifications = paginate(current_user.company.web_notifications.where(read_status: params[:read_status]).order(:created_at).reverse_order)

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

          desc 'Update notification status.'
          params do
            requires :notification, type: Hash do
              requires :id, type: Integer, allow_blank: false
              requires :read_status, type: Boolean, allow_blank: false
            end
          end
          post 'update_status' do
            notification = current_user.company.web_notifications.find_by(id: params[:notification][:id])
            error!("Notification not found." , 404) unless notification.present?

            if notification.update(read_status: params[:notification][:read_status])
              { message: 'Notification updated successfully.'}
            else
              error!(notification.errors.full_messages , 400)
            end
          end
        end
      end
    end
  end
end