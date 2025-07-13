Rails.application.routes.draw do
  resources :registrations

  match "/login", to: "sessions#user_login", via: :post
  match "/refresh_token", to: "sessions#refresh_session_token", via: :post
  match "/admin_login", to: "sessions#admin_login", via: :post
  match "/send_otp", to: "otps#send_otp", via: :post
  match "/resend_otp", to: "registrations#resend_otp", via: :post
  match "/validate_otp", to: "registrations#validate_otp", via: :post
  post "/forgot_password", to: "passwords#forgot_password"
  post "/reset_password", to: "passwords#reset_password"
end
