class ApplicationController < ActionController::API
  # set_current_tenant_by_subdomain(:dealer, :subdomain)
  before_action :set_current_tenant
  before_action :authorize_request

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
    subdomain = request.headers["Dealer-Subdomain"]
    dealer_id = request.headers["Dealer-Id"]

    if subdomain.present?
      dealer = Dealer.find_by(subdomain: subdomain)
    elsif dealer_id.present?
      dealer = Dealer.find_by(id: dealer_id)
    end

    if dealer
      ActsAsTenant.current_tenant = dealer
    else
      render json: { error: "Dealer not found" }, status: :unauthorized
    end
  end
end
