class UserMailer < ApplicationMailer
  def reset_password_email
    @user = params[:user]
    @url = "#{ENV.fetch('EMAIL_URL', 'biz.easysell@gmail.com')}/reset-password/#{@user[:reset_password_token]}"
    mail(to: @user.email, subject: "Reset your password")
  end
end
