class UserMailer < ApplicationMailer

  def reset_password_mail(user)
    @user = user
    @reset_link  = "http://limologix.softwaystaging.com/#/core/reset_password?token=#{@user.reset_password_token}"
    mail(to: @user.email, subject: 'Reset password instructions')
  end
end