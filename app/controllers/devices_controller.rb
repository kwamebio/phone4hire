class DevicesController < ApplicationController
  def index
    devices = Device.paginate(page: params[:page], per_page: params[:per_page] || 10)
      render json: {
        devices: devices,
        current_page: devices.current_page,
        total_pages: devices.total_pages,
        total_entries: devices.total_entries
      }, status: :ok
  end

  def show
    device = Device.find(params[:id])
    if device
      render json: device, status: :ok
    else
      render json: { error: "Device not found" }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue => e
    render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
  end

  def create
    device = Device.create!(device_params)
    if device
      render json: { message: "Device created successfully", device: device }, status: :created
    else
      render json: { error: "Failed to create device" }, status: :unprocessable_entity
    end
  end

  def assign_device_to_user
    device = Device.find(params[:id])
    user = User.find_by(id: params[:user_id])

    if device && user
      device.update(user_id: user.id, status: "assigned")
      render json: { message: "Device assigned to user successfully", device: device }, status: :ok
    else
      render json: { error: "Device or User not found" }, status: :not_found
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue => e
    render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
  end

  private

  def device_params
    params.require(:device).permit(:name, :imei, :serial_number, :model, :device_description, :purchasing_price, :status, :user_id, :dealer_id
    )
  end
end
