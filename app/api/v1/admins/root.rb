module V1
  module Admins
    class Root < Base
      version 'v1'

      helpers do
        def authenticate!
          error!('Unauthorized. Invalid or expired token.', 401) unless current_admin
        end

        def current_admin
          return false unless headers['Auth-Token'].present?

          @admin ||= Admin.find_by(auth_token: headers['Auth-Token'])

          (@admin.present? && !@admin.auth_token_expired?) ? @admin : nil
        end
      end

      mount SessionsEndpoint
      mount DriversEndpoint
    end
  end
end