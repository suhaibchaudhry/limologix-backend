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
      get 'states' do
        states = []
        CS.states(params[:country_code].to_sym).each {|key, value| states << {code: key.to_s, name: value.to_s }}
        {
          message: 'States list',
          data: states
        }
      end
    end
  end
end