class DealerMailer < ApplicationMailer
  def send_otp_email
    @dealer = params[:dealer]
    @url = "#{ENV.fetch('EMAIL_URL', 'biz.easysell@gmail.com')}/verify-account/#{@dealer[:otp_code]}"
    @otp = params[:otp]
    mail(to: @dealer.email, subject: "Your OTP Code")
  end
end
