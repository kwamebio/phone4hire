class SuperAdminController < ApplicationController
  skip_before_action :set_current_tenant, only: [ :total_tenants, :total_users, :total_revenue, :contracts ]
  def total_tenants
    ActsAsTenant.without_tenant do
      @total_tenants = Dealer.count
      render json: { total_tenants: @total_tenants }
    end
  end

  def total_users
    ActsAsTenant.without_tenant do
      @total_users = User.count
      render json: { total_users: @total_users }
    end
  rescue => e
    render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
  end

  def total_revenue
  end

  def contracts
  end
end
