class UserMailer < ApplicationMailer
  default from: "avinash.thummurugoti@softwaysolutions.com"

  def reset_password_mail(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Reset password instructions')
  end
end
