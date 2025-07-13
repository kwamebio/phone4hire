class RegistrationsController < ApplicationController
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  def show
  end

  def create
    @user = User.create!(user_params)
    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def send_otp
    user = User.find_by(email: params[:email])
    otp_code_generated = user.generate_otp_code
    if user
       Otp.create!(
        otp_code: otp_code_generated,
        verify_status: false,
        delivery_status: false,
        expires_at: 10.minutes.from_now,
        owner: user
      )
      user.send_otp_email
      render json: { message: "OTP sent successfully" }, status: :ok
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


  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :status, :home_address, :national_id, :password, :password_confirmation)
  end
end
