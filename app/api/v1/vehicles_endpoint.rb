module V1
  class VehiclesEndpoint < Root
    namespace :vehicle do
      desc 'Returns list of vehicle types' do
        http_codes [ { code: 201, message: { status: 'success', message: 'Vehicle types list'}.to_json }]
      end
      paginate per_page: 30, max_per_page: 30, offset: false
      post 'types' do
        {
          message: 'Vehicle types list',
          data:
          {
            vehicles: serialize_model_object(VehicleType.first)
          }
        }
      end
    end
  end
end