class RegistrationsController < ApplicationController
  skip_before_action :authorize_request, only: [ :create ]
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.create!(user_params)
      send_otp(@user)
      Otp.update!(delivery_status: true)
      render json: { message: "An otp has been sent to your email", user: @user }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue => e
      render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
  end

  def resend_otp
    user = User.find_by(email: params[:email])
    if user
      send_otp(user)
      Otp.update!(delivery_status: true)
      render json: { message: "OTP resent successfully" }, status: :ok
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  def validate_otp
    user = User.find_by(email: params[:email])
    otp = Otp.find_by(otp_code: params[:otp_code], owner: user)

    if otp && !otp.verify_status && otp.expires_at > Time.current
      otp.update(verify_status: true, delivery_status: true)
      render json: { message: "OTP validated successfully" }, status: :ok
    else
      render json: { error: "Invalid or expired OTP" }, status: :unprocessable_entity
    end
  end

  private

  def send_otp(user)
    otp_code_generated = user.generate_otp_code
       otp = Otp.create!(
            otp_code: otp_code_generated,
            verify_status: false,
            delivery_status: false,
            expires_at: 10.minutes.from_now,
            owner: user
      )
      user.send_otp_email(otp)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :status, :home_address, :national_id, :password, :password_confirmation)
  end
end
