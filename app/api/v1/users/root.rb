module V1
  module Users
    class Root < Base

      helpers do
        def authenticate!
          error!('Unauthorized. Invalid or expired token.', 401) unless current_user
        end

        def current_user
          return false unless headers['Auth-Token'].present?

          @user ||= User.find_by(auth_token: headers['Auth-Token'])

          (@user.present? && !@user.auth_token_expired?) ? @user : nil
        end
      end

      mount RegistrationsEndpoint
      mount SessionsEndpoint
      mount PasswordsEndpoint
      mount ProfilesEndpoint
      mount CompaniesEndpoint
      mount CustomersEndpoint
      mount TripsEndpoint
      mount VehiclesEndpoint
      mount DriversEndpoint
    end
  end
end