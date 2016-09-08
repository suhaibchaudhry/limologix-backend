module V1
  module Drivers
    class PasswordsEndpoint < Root
      namespace :drivers do
        desc 'Verifies email and send reset password mail' do
          http_codes [ { code: 201, message: { status: 'success', message: 'Email has been sent to registered email address.' }.to_json },
            { code: 404, message: { status: 'error', message: 'Email not found.' }.to_json }]
        end
        params do
          requires :email, type: String, allow_blank: false
        end
        post 'forgot_password' do
          driver = Driver.find_by(email: params[:email])

          if driver.present? && driver.update_reset_password_token!
            DriverMailer.reset_password_mail(driver).deliver_now
            { message: 'Email has been sent to registered email address.' }
          else
            error!('Email not found.', 404)
          end
        end
      end
    end
  end
end