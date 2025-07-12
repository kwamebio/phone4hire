class SessionsController < ApplicationController
  def user_login
    user = nil
    ActsAsTenant.without_tenant do
    user = User.find_by(email: params[:email])
     end
    if user&.authenticate(params[:password])
      ActsAsTenant.current_tenant = user.dealer

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
    admin = nil
    ActsAsTenant.without_tenant do
    admin = Admin.find_by(email: params[:email])
     end
    if admin&.authenticate(params[:password])
      ActsAsTenant.current_tenant = admin.dealer

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

  def refresh_session_token
    session = Session.find_by(token: params[:token])
    if session
      new_token = JsonWebToken.encode(user_id: session.owner.id)
      decoded = JsonWebToken.decode(new_token)

      session.update!(
        token: new_token,
        expired_at: Time.at(decoded["exp"]),
        last_active_at: Time.current
      )

      render json: { message: "Session token refreshed", token: new_token }, status: :ok
    else
      render json: { error: "Session not found" }, status: :not_found
    end
  end
end
