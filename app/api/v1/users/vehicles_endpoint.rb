module V1
  module Users
    class VehiclesEndpoint < Root
      before do
        authenticate!
      end

      namespace :users do
        namespace :vehicles do

          desc 'List of vehicle types.' do
            headers 'Auth-Token': { description: 'Validates your identity', required: true }

            http_codes [ { code: 201, message: { status: 'success', message: 'Vehicle types list.',
              data: {
                vehicle_types: [{"id":1,"name":"suv","description":"Hic odit distinctio cum sequi dolores tempore.","capacity":9,"image":"/uploads/vehicle_type/image/1/dummy_image_9.png"},
                  {"id":2,"name":"van","description":"Optio sed et veniam eum.","capacity":7,"image":"/uploads/vehicle_type/image/2/dummy_image_7.png"}]
              }
            }.to_json }]
          end
          get 'types' do
            {
              message: 'Vehicle types list.',
              data:
              {
                vehicle_types: serialize_model_object(VehicleType.all)
              }
            }
          end

        end
      end
    end
  end
end