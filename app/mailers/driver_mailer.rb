class DriverMailer < ApplicationMailer

  def reset_password_mail(driver)
    @driver = driver
    @reset_link  = "http://limologix.softwaystaging.com/#/core/reset_password?token=#{@driver.reset_password_token}"
    mail(to: @driver.email, subject: 'Reset password instructions')
  end
end
