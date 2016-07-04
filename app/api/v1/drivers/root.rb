module V1
  module Drivers
    class Root < Base

      helpers do
        def authenticate!
          error!('Unauthorized. Invalid or expired token.', 401) unless current_driver
        end

        def current_driver
          return false unless headers['Auth-Token'].present?

          @driver ||= Driver.find_by(auth_token: headers['Auth-Token'])

          (@driver.present? && !@driver.auth_token_expired?) ? @driver : nil
        end

        def check_whether_driver_approved
          error!('Your account is in approval process.', 403) if current_driver.pending?
          error!('Your account has been disapproved.', 403) if current_driver.disapproved?
          error!('Your account is blocked.', 403) if current_driver.blocked?
        end
      end

      mount RegistrationsEndpoint
      mount SessionsEndpoint
      mount PasswordsEndpoint
      mount ProfilesEndpoint
      mount TripsEndpoint
    end
  end
end