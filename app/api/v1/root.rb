require 'grape-swagger'
module V1
  class Root < Base
    version 'v1'

    helpers do
      def authenticate!
        error!('Unauthorized. Invalid or expired token.', 401) unless request.url.include?("users") ? current_user : current_driver
      end

      def current_user
        return false unless params[:auth_token].present?

        user = User.find_by(auth_token: params[:auth_token])

        (user.present? && !user.auth_token_expired?) ? user : nil
      end

      def current_driver
        return false unless params[:auth_token].present?

        driver = Driver.find_by(auth_token: params[:auth_token])

        (driver.present? && !driver.auth_token_expired?) ? driver : nil
      end
    end

    mount V1::Users::RegistrationsEndpoint
    mount V1::Users::SessionsEndpoint
    mount V1::Users::PasswordsEndpoint
    mount V1::Users::CompaniesEndpoint
    mount V1::Users::CustomersEndpoint
    mount V1::Users::TripsEndpoint
    mount V1::MasterDataEndpoint
    mount V1::VehiclesEndpoint
  end
end