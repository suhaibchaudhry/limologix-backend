require 'grape-swagger'
module V1
  class Root < Base
    version 'v1'
    format :json

    helpers do
      def authenticate!
        error!({ message: 'Unauthorized. Invalid or expired token.'}, 401) unless current_user
      end

      def current_user
        return false unless params[:auth_token].present?
        user = User.find_by(auth_token: params[:auth_token])
        (user.present? && !user.auth_token_expired?) ? user : nil
      end
    end

    mount V1::Users::RegistrationsEndpoint
    mount V1::Users::SessionsEndpoint
    add_swagger_documentation
  end
end