module V1
  module Users
    class AdvertisementsEndpoint < Root
      authorize_routes!

      before do
        authenticate!
      end

      namespace :users do
        namespace :advertisements do

          desc 'Advertisement posters list.'
          paginate per_page: 20, max_per_page: 30, offset: false
          post 'index', authorize: [:index, AdvertisementsEndpoint] do
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

          desc 'Add advertisement posters.'
          params do
            requires :posters, type: Array do
              requires :name, type: String, allow_blank: false
              requires :image, type: String, allow_blank: false
            end
          end
          post 'create', authorize: [:create, AdvertisementsEndpoint] do
            errors = [];
            params[:posters].each do |poster|
              advertisement = Advertisement.new(poster: decode_base64_image(poster[:name], poster[:image]))
              errors << "#{poster[:name]} #{advertisement.errors.full_messages}" unless advertisement.save
            end

            if errors.present?
              error!(errors.join(',') , 400)
            else
              { message: "Advertisement posters uploaded successfully." }
            end
          end

        end
      end

    end
  end
end