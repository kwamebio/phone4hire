class OtpMailer < ApplicationMailer
  def send_otp_email
    @user = params[:user]
    @otp = params[:otp]
    mail(to: @user.email, subject: "Your OTP Code")
  end
end
