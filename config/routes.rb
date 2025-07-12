Rails.application.routes.draw do
  resources :registrations

  match "/login", to: "sessions#user_login", via: :post
  match "/refresh_token", to: "sessions#refresh_session_token", via: :post
  match "/admin_login", to: "sessions#admin_login", via: :post
end
