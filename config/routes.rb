Rails.application.routes.draw do
  resources :registrations

  # routes for users
  match "/login", to: "sessions#user_login", via: :post
  match "/refresh_token", to: "sessions#refresh_session_token", via: :post
  match "/admin_login", to: "sessions#admin_login", via: :post
  match "/send_otp", to: "otps#send_otp", via: :post
  match "/resend_otp", to: "registrations#resend_otp", via: :post
  match "/validate_otp", to: "registrations#validate_otp", via: :post
  post "/forgot_password", to: "passwords#forgot_password"
  post "/reset_password", to: "passwords#reset_password"

  # routes for devices
  match "/devices", to: "devices#index", via: :get
  match "/devices/:id", to: "devices#show", via: :get
  match "/devices", to: "devices#create", via: :post
  match "/devices/assign", to: "devices#assign_device_to_user", via: :post

  # routes for super admin
  match "/total_tenants", to: "super_admin#total_tenants", via: :get
  match "/total_users", to: "super_admin#total_users", via: :get
  match "/total_revenue", to: "super_admin#total_revenue", via: :get
  match "/contracts", to: "super_admin#contracts", via: :get
end
