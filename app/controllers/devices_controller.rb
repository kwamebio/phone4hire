class DevicesController < ApplicationController
  require "csv"

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

    if device && user && device.status == "available"  # && user.account_verification == true
      device.update(user_id: user.id, status: "assigned")
      render json: { message: "Device assigned to user successfully", device: device }, status: :ok
    else
      render json: { error: "Device or User not found or has already been assigned" }, status: :not_found
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  rescue => e
    render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
  end

  def bulk_upload_devices_csv
    file = params[:file]
    uploaded_devices = []

    if file.blank?
      return render json: { error: "No file provided" }, status: :bad_request
    end

    begin
      index = 0
      CSV.foreach(file, headers: true) do |row|
        index += 1

        required_fields = %w[name imei serial_number model device_description purchasing_price status]
        missing_fields = required_fields.select { |field| row[field].blank? }
        unless missing_fields.empty?
          render json: { error: "Missing required fields at row #{index}: #{missing_fields.join(', ')}" }, status: :unprocessable_entity and return
        end

        devices =  Device.find_or_create_by(imei: row["imei"]) do |d|
                d.name = row["name"]
                d.serial_number = row["serial_number"]
                d.model = row["model"]
                d.device_description = row["device_description"]
                d.purchasing_price = row["purchasing_price"]
                d.status = row["status"]
        end

        if devices.persisted?
          uploaded_devices << devices
        else
          return render json: {
            error: "Failed to create device at row #{index}",
            validation_errors: devices.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      render json: { message: "Devices uploaded successfully", devices: uploaded_devices }, status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: "Invalid data in CSV file: #{e.record.errors.full_messages.join(', ')}" }, status: :unprocessable_entity
    rescue => e
      render json: { error: "Something went wrong: #{e.message}" }, status:
    end
  end

  def export_csv_data
  devices = Device.all

  csv_data = CSV.generate(headers: true) do |csv|
    columns = Device.column_names
    csv << columns

    devices.each do |device|
      csv << columns.map { |column| device.send(column) }
    end
  end

  send_data csv_data,
            filename: "devices_#{Time.current.strftime('%Y%m%d_%H%M%S')}.csv",
            type: "text/csv"
  rescue => e
    render json: { error: "Something went wrong: #{e.message}" }, status: :internal_server_error
  end


  private

  def device_params
    params.require(:device).permit(:name, :imei, :serial_number, :model, :device_description, :purchasing_price, :status, :user_id, :dealer_id
    )
  end
end
