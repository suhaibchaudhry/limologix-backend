module V1
  module Users
    class DriversEndpoint < Root
      authorize_routes!

      before do
        authenticate!
      end

      namespace :users do
        namespace :drivers do
          desc 'Drivers list'
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index', each_serializer: DriverVehicleSerializer do
            drivers = paginate(Driver.all.order(:created_at).reverse_order)

            if drivers.present?
              {
                message: 'Drivers list.',
                data: {
                  drivers: serialize_model_object(drivers)
                }
              }
            else
              { message: 'No results found.'}
            end
          end

          desc 'Get driver details.'
          params do
            requires :driver, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'show', serializer: DriverVehicleSerializer do
            driver = Driver.find_by(id: params[:driver][:id])

            if driver.present?
              {
                message: 'Drivers details.',
                data: {
                  driver: serialize_model_object(driver)
                }
              }
            else
              error!('Driver not found.', 404)
            end
          end

          Driver::SUPER_ADMIN_ACTIONS.each do |action, status|
            desc "#{action} a driver."
            params do
              requires :driver, type: Hash do
                requires :id, type: Integer, allow_blank: false
              end
            end
            post "#{action}", authorize: [:status_update, DriversEndpoint] do
              driver = Driver.find_by(id: params[:driver][:id])
              error!('Driver not found.', 404) unless driver.present?

              if driver.send("#{action}!")
                { message: "Driver #{status} successfully." }
              else
                error!(driver.errors.full_messages , 400)
              end
            end
          end

        end
      end
    end
  end
end
