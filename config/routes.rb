Rails.application.routes.draw do
  root "home#index"

  # Devise routes first to avoid conflicts
  devise_for :users
  get "users/sign_out", to: "devise/sessions#destroy", as: :get_sign_out

  resources :photos do
    collection do
      get :feeds
      get :discover
    end
  end

  resources :albums do
    collection do
      get :feeds
      get :discover
    end
  end

  # Users resources with path constraint to avoid devise conflicts
  resources :users, only: [ :show ], constraints: { id: /\d+/ } do
    member do
      get :photos
      get :albums
      get :following
      get :followers
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
