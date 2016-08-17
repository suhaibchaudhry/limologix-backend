module V1
  class MasterDataEndpoint < Base
    namespace :master_data do
      desc 'Returns list of countries'
      get 'countries' do
        {
          message: 'Countries list',
          data: [
            { code: "US", name: "United States" },
            { code: "CA", name: "Canada"}
          ]
        }
      end

      desc 'Returns list of states in country'
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

      # desc 'Returns list of companies' do
      #   http_codes [ { code: 201, message: { status: 'success', message: 'Companies list', data: [{ id: 1, name: "Softway" }, { id: 2, name: "TCS"}] }.to_json }]
      # end
      # paginate per_page: 20, max_per_page: 30, offset: false
      # post 'companies' do
      #   {
      #     message: 'Companies list',
      #     data: Company.all.map{|company| { id: company.id, name: company.name }}
      #   }
      # end

      desc 'Advertisement posters list.'
      paginate per_page: 20, max_per_page: 30, offset: false
      post 'advertisements' do
        advertisements = paginate(Advertisement.all.order(:created_at).reverse_order)

        if advertisements.present?
          {
            message: 'Advertisements list.',
            data: {
              advertisements: serialize_model_object(advertisements)
            }
          }
        else
          { message: 'No results found.'}
        end
      end

      namespace :vehicles do
        desc 'List of vehicle types.'
        get 'types' do
          {
            message: 'Vehicle types list.',
            data:
            {
              vehicle_types: serialize_model_object(VehicleType.all)
            }
          }
        end

        desc 'List of vehicle makes.'
        params do
          requires :vehicle_type_id, type: Integer, allow_blank: false
        end
        post 'makes' do
          vehicle_type = VehicleType.find_by(id: params[:vehicle_type_id])
          error!("Vehicle type not found." , 404) unless vehicle_type.present?

          if vehicle_type.vehicle_makes.present?
            {
              message: 'Vehicle makes list.',
              data:
              {
                vehicle_makes: serialize_model_object(vehicle_type.vehicle_makes)
              }
            }
          else
            { message: 'No results found.'}
          end
        end

        desc 'List of vehicle models.'
        params do
          requires :vehicle_type_id, type: Integer, allow_blank: false
          requires :vehicle_make_id, type: Integer, allow_blank: false
        end
        post 'models' do
          vehicle_type = VehicleType.find_by(id: params[:vehicle_type_id])
          error!("Vehicle type not found." , 404) unless vehicle_type.present?

          vehicle_make = VehicleMake.find_by(id: params[:vehicle_make_id])
          error!("Vehicle make not found." , 404) unless vehicle_make.present?

          vehicle_make_type = VehicleMakeType.where(vehicle_type_id: vehicle_type.id, vehicle_make_id: vehicle_make.id).first
          error!("Vehicle models of this type or make not found." , 404) unless vehicle_make_type.present?

          vehicle_models = vehicle_make_type.vehicle_models

          if vehicle_models.present?
            {
              message: 'Vehicle models list.',
              data:
              {
                vehicle_models: serialize_model_object(vehicle_models)
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