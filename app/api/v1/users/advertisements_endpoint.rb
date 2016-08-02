module V1
  module Users
    class AdvertisementsEndpoint < Root
      authorize_routes!

      before do
        authenticate!
      end

      namespace :users do
        namespace :advertisements do

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

          desc 'Remove an advertisement poster.'
          params do
            requires :advertisement, type: Hash do
              requires :id, type: Integer, allow_blank: false
            end
          end
          post 'delete', authorize: [:delete, AdvertisementsEndpoint] do

            advertisement = Advertisement.find_by(id: params[:advertisement][:id])

            if advertisement.present?
              advertisement.destroy

              {message: "Advertisement poster deleted successfully."}
            else
              error!("Advertisement poster not found." , 404)
            end
          end

        end
      end

    end
  end
end