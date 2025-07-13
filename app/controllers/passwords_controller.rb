class PasswordsController < ApplicationController
  def forgot_password
    user = User.find_by(params[:email])

    if user
      user.generate_password_token!
      user.send_reset_password_mail
      render json: { message: "Reset password email sent successfully" }, status: :ok
    end
  end

  def reset_password
    user = User.find_by(reset_password_token: params[:token])

    if user && user.token_valid?
      if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
        user.save!
        render json: { message: "Password reset successfully" }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
