class ApplicationController < ActionController::API
  set_current_tenant_through_filter
  before_action :authorize_request
  before_action :set_current_tenant

  attr_reader :current_user, :current_admin

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split.last if header.present?
    decoded = JsonWebToken.decode(token)

    if decoded && decoded["user_id"]
      @current_user = User.find_by(id: decoded["user_id"])
    elsif decoded && decoded["admin_id"]
      @current_admin = Admin.find_by(id: decoded["admin_id"])
    end
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: "Invalid token" }, status: :unauthorized
  end

  def set_current_tenant
    subdomain = request.subdomains.first
    puts "Subdomain:----------------------------- #{subdomain.inspect}"
    if subdomain.present?
      dealer = Dealer.find_by(subdomain: subdomain)
      if dealer
        ActsAsTenant.current_tenant = dealer
      else
        render json: { error: "Tenant not found" }, status: :not_found
      end
    else
      render json: { error: "Subdomain not provided" }, status: :bad_request
    end
  end
end
