class SessionsController < ApplicationController
  def user_login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      decoded = JsonWebToken.decode(token)

      user_agent_string = request.user_agent

      Session.create!(
        owner: user,
        token: token,
        expired_at: Time.at(decoded["exp"]),
        ip_address: request.remote_ip,
        user_agent: user_agent_string,
        last_active_at: Time.current
      )

      render json: { message: "Login successful", token: token, user: user.as_json.except("password_digest") }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def admin_login
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      token = JsonWebToken.encode(admin_id: admin.id)
      decoded = JsonWebToken.decode(token)

      user_agent_string = request.user_agent

      Session.create!(
        owner: admin,
        token: token,
        expired_at: Time.at(decoded["exp"]),
        ip_address: request.remote_ip,
        user_agent: user_agent_string,
        last_active_at: Time.current
      )

      render json: { message: "Admin login successful", token: token, user: admin.as_json.except("password_digest") }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
