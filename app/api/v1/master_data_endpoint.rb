module V1
  class MasterDataEndpoint < Root
    namespace :master_data do
      desc 'Returns list of countries' do
        detail 'success => {status: "success", message: "Country list", data: {}}'
      end
      post 'countries' do
        success_json("Countries list",{
            US: "United States",
            CA: "Canada"
          })
      end

      desc 'Returns list of states in country' do
        detail 'success => {status: "success", message: "Country list", data: {}}'
      end
      params do
        requires :country_code, type: String, allow_blank: false
      end
      post 'states' do
        success_json("States list", CS.states(params[:country_code].to_sym))
      end
    end
  end
end