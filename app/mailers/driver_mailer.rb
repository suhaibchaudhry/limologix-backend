class DriverMailer < ApplicationMailer

  def reset_password_mail(driver)
    @driver = driver
    type = driver.class.name
    @reset_link  = "https://dispatch.limologix.com/#/core/reset_password?token=#{@driver.reset_password_token}&type=#{type}"
    mail(to: @driver.email, subject: 'Reset password instructions')
  end
end
