module V1
  class MasterDataEndpoint < Root
    namespace :master_data do
      desc 'Returns list of countries' do
        http_codes [ { code: 201, message: { status: 'success', message: 'Countries list', data: [{ code: "US", name: "United States" }, { code: "CA", name: "Canada"}] }.to_json }]
      end
      get 'countries' do
        {
          message: 'Countries list',
          data: [
            { code: "US", name: "United States" },
            { code: "CA", name: "Canada"}
          ]
        }
      end

      desc 'Returns list of states in country' do
        http_codes [ { code: 201, message: { status: 'success', message: 'States list', data: [{ "code": "AB","name": "Alberta"},{"code": "BC", "name": "British Columbia"}] }.to_json } ]
      end
      params do
        requires :country_code, type: String, allow_blank: false
      end
      post 'states' do
        states = []
        CS.states(params[:country_code].to_sym).each {|key, value| states << {code: key.to_s, name: value.to_s }}
        {
          message: 'States list',
          data: states
        }
      end

      namespace :vehicles do
        desc 'List of vehicle types.' do
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