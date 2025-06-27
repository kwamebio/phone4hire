Rails.application.routes.draw do

  resources :users
  match '/login', to: 'sessions#login', via: :post
end
