class SessionsController < ApplicationController

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      payload = {
      user_id: user.id,
      expiration: 24.hours.from_now
    }
      Session.create(user_id: user.id,
                     token: token,
                      expired_at: payload[:expiration],
                      last_active_at: Time.current
                      )

      render json: { message: "Login successful", token: token}, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
