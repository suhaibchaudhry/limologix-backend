module V1
  module Users
    class DriversEndpoint < Root
      authorize_routes!

      before do
        authenticate!
      end

      namespace :users do
        namespace :drivers do
          desc 'Drivers list' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [
              { code: 200, message: { status: 'success', message: 'Customers list.',
                data: {
                  drivers: [{id: 1, first_name: 'Avinash', last_name: 'T', mobile_number: '78787878', email: 'avinash123@yopmail.com', status: 'pending'},
                    {id: 2, first_name: 'Avinash', last_name: 'T', mobile_number: '78787878', email: 'avinash123@yopmail.com', status: 'pending'}]
                  }
                }.to_json },
              { code: 201, message: { status: 'success', message: 'No results found.'}.to_json }]
          end
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index', each_serializer: DriverVehicleSerializer, authorize: [:index, DriversEndpoint] do
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

          desc 'Get driver details.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [
              {
                code: 200,
                message: {
                  status: 'success',
                  message: 'Drivers details.',
                  data: {
                    driver: {
                      id: 1,
                      first_name: 'Avinash',
                      last_name: 'T',
                      mobile_number: '78787878',
                      email: 'avinash123@yopmail.com',
                      license_number: 'L456',
                      license_expiry_date: '2016-06-08',
                      license_image: {
                        name: 'License.jpg',
                        image: '/uploads/driver/license_image/1/License.jpg'
                      },
                      badge_number: 'B456',
                      badge_expiry_date: '2016-06-08',
                      ara_image: {
                        name: 'ARA.jpg',
                        image: '/uploads/driver/ara_image/1/ARA.jpg'
                      },
                      ara_expiry_date: '2016-06-08',
                      insurance_company: 'LIMO',
                      insurance_policy_number: 'IN456',
                      insurance_expiry_date: '2016-06-08',
                      status: 'pending',
                      address: {
                        street: 'adsdasdasdasd',
                        city: 'texas',
                        zipcode: 52014,
                        state: {
                          code: 'AL',
                          name: 'Alabama'
                        },
                        country: {
                          code: 'US',
                          name: 'United States'
                        }
                      }
                    }
                  }
                }.to_json
              },
              { code: 201, message: { status: 'success', message: 'No results found.'}.to_json }]
          end
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
            desc "#{action} a driver." do
              headers 'Auth-Token': { description: 'Validates your identity', required: true }

              http_codes [
                { code: 200, message: { status: 'success', message: "Driver #{status} successfully."}.to_json },
                { code: 404, message: { status: 'success', message: 'Driver not found.'}.to_json }]
            end
            params do
              requires :driver, type: Hash do
                requires :id, type: Integer, allow_blank: false
              end
            end
            post "#{action}", authorize: [:status_update, DriversEndpoint] do
              driver = Driver.find_by(id: params[:driver][:id])

              if driver.present?
                driver.send("#{action}!")

                { message: "Driver #{status} successfully." }
              else
                error!('Driver not found.', 404)
              end
            end
          end

        end
      end
    end
  end
end