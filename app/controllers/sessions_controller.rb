class SessionsController < ApplicationController
  def user_login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      decoded = JsonWebToken.decode(token)

      user_agent_string = request.user_agent
      ua = UserAgent.parse(user_agent_string)

      Session.create!(
        user_id: user.id,
        token: token,
        expired_at: Time.at(decoded["exp"]),
        ip_address: request.remote_ip,
        user_agent: user_agent_string,
        # browser: ua.browser,
        # os: ua.platform,
        # device_type: ua.mobile? ? "Mobile" : "Desktop",
        last_active_at: Time.current
      )

      render json: { message: "Login successful", token: token, user_agent: { browser: ua.browser, os: ua.platform, device_type: ua.mobile? ? "Mobile" : "Desktop" } }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def admin_login
    admin = Admin.find_by(email: params[:email])
    if admin&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: admin.id)
      decoded = JsonWebToken.decode(token)

      user_agent_string = request.user_agent
      ua = UserAgent.parse(user_agent_string)

      Session.create!(
        user_id: admin.id,
        token: token,
        expired_at: Time.at(decoded["exp"]),
        ip_address: request.remote_ip,
        user_agent: user_agent_string,
        # browser: ua.browser,
        # os: ua.platform,
        # device_type: ua.mobile? ? "Mobile" : "Desktop",
        last_active_at: Time.current
      )

      render json: { message: "Admin login successful", token: token, user_agent: { browser: ua.browser, os: ua.platform, device_type: ua.mobile? ? "Mobile" : "Desktop" } }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
