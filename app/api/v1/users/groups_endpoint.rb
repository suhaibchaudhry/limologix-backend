module V1
  module Users
    class GroupsEndpoint < Root

      before do
        authenticate!
      end

      namespace :users do
        namespace :groups do

          desc 'List all groups.'
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index', each_serializer: GroupsArraySerializer do
            groups = paginate(current_user.company.groups.order(:created_at).reverse_order)

            if groups.present?
              {
                message: 'groups list.',
                data: {
                  groups: serialize_model_object(groups)
                }
              }
            else
              { message: 'No results found.'}
            end
          end

          desc 'Create a group.'
          params do
            requires :group, type: Hash do
              requires :name, type: String, allow_blank: false
              requires :description, type: String, allow_blank: false
            end
          end
          post 'create' do
            group = current_user.company.groups.new(name: params[:group][:name], description: params[:group][:description])

            if group.save
              {
                message: 'Group created successfully.',
                data: {
                  group: serialize_model_object(group)
                }
              }
            else
              error!(group.errors.full_messages , 400)
            end
          end

          desc 'Show group with drivers.'
          params do
            requires :group, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'show' do
            group = current_user.company.groups.find_by(id: params[:group][:id])

            if group.present?
              {
                message: 'Group data.',
                data: {
                  group: serialize_model_object(group)
                }
              }
            else
              error!("Group not found." , 404)
            end
          end

          desc 'Delete a group.'
          params do
            requires :group, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'delete' do
            group = current_user.company.groups.find_by(id: params[:group][:id])

            if group.present?
              group.destroy

              {message: "Group deleted successfully."}
            else
              error!("Group not found." , 404)
            end
          end

          desc 'Add drivers to group.'
          params do
            requires :group, type: Hash do
              requires :id, type: Integer, allow_blank: false
              requires :driver_ids, type: Array[Integer], allow_blank: false
            end
          end
          post 'add_drivers' do
            group = current_user.company.groups.find_by(id: params[:group][:id])
            error!("Group not found." , 404) unless group.present?

            begin
              group.driver_ids = group.driver_ids + params[:group][:driver_ids]

              {message: "Drivers added successfully."}
            rescue => e
              error!("Couldn't find all Drivers" , 400)
            end
          end

          desc 'Remove drivers from group.'
          params do
            requires :group, type: Hash do
              requires :id, type: Integer, allow_blank: false
              requires :driver_ids, type: Array[Integer], allow_blank: false
            end
          end
          post 'remove_drivers' do
            group = current_user.company.groups.find_by(id: params[:group][:id])
            error!("Group not found." , 404) unless group.present?

            begin
              group.driver_ids = group.driver_ids - params[:group][:driver_ids]

              {message: "Drivers removed successfully."}
            rescue => e
              error!("Couldn't find all Drivers" , 400)
            end
          end

          desc 'Get drivers in group.'
          params do
            requires :group, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'get_drivers', each_serializer: DriversArraySerializer do
            group = current_user.company.groups.find_by(id: params[:group][:id])
            error!("Group not found." , 404) unless group.present?

            drivers = group.drivers

            if drivers.present?
              {
                message: 'List of drivers in group.',
                data: {
                  drivers: serialize_model_object(drivers)
                }
              }
            else
              { message: 'No results found.'}
            end
          end

          desc 'Get list of drivers not in group.'
          params do
            requires :group, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'get_drivers_not_in_group', each_serializer: DriversArraySerializer do
            group = current_user.company.groups.find_by(id: params[:group][:id])
            error!("Group not found." , 404) unless group.present?

            drivers = paginate(Driver.where("id NOT IN(?)", group.driver_ids).order(:created_at).reverse_order)

            if drivers.present?
              {
                message: 'List of drivers not in group.',
                data: {
                  drivers: serialize_model_object(drivers)
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