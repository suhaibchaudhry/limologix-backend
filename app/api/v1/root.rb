require 'grape-swagger'
module V1
  class Root < Base
    version 'v1'
    format :json

    helpers do
      def authenticate!
        error_json(401, 'Unauthorized. Invalid or expired token.') unless current_user
      end

      def current_user
        return false unless params[:auth_token].present?
        user = User.find_by(auth_token: params[:auth_token])
        (user.present? && !user.auth_token_expired?) ? user : nil
      end

      def error_json(response_code, message, data=nil)
        error!({ message: message, data: data }, response_code)
      end

      def success_json(message, data=nil)
        {
          status: "success",
          message: message,
          data: data
        }
      end
    end

    mount V1::Users::RegistrationsEndpoint
    mount V1::Users::SessionsEndpoint
    mount V1::Users::PasswordsEndpoint
    mount V1::MasterDataEndpoint
    add_swagger_documentation
  end
end