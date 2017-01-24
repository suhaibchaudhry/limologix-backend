class UserMailer < ApplicationMailer

  def reset_password_mail(user)
    @user = user
    type = user.class.name
    @reset_link  = "https://dispatch.limologix.com/#/core/reset_password?token=#{@user.reset_password_token}&type=#{type}"
    mail(to: @user.email, subject: 'Reset password instructions')
  end

  def driver_account_creation_mail(driver)
    @driver = driver
    @user = User.super_admin
    mail(to: @user.email, subject: 'New Driver registration')
  end
end
