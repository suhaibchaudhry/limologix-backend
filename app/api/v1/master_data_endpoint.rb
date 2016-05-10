module V1
  class MasterDataEndpoint < Root
    namespace :master_data do
      desc 'Returns list of countries' do
        http_codes [ { code: 201, message: { status: 'success', message: 'Countries list', data: { US: 'United States', CA: 'Canada' } }.to_json }]
      end
      post 'countries' do
        {
          message: 'Countries list',
          data: { US: 'United States', CA: 'Canada' }
        }
      end

      desc 'Returns list of states in country' do
        http_codes [ { code: 201, message: { status: 'success', message: 'States list', data: { AB: 'Alberta', BC: 'British Columbia' } }.to_json } ]
      end
      params do
        requires :country_code, type: String, allow_blank: false
      end
      post 'states' do
        {
          message: 'States list',
          data: CS.states(params[:country_code].to_sym)
        }
      end
    end
  end
end