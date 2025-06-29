Rails.application.routes.draw do
  resources :users
  match "/login", to: "sessions#login", via: :post
  match "/admin_login", to: "sessions#admin_login", via: :post
end
