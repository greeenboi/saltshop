Rails.application.routes.draw do
  # Resources that aren't directly accessible (used internally)
  resources :order_items
  resources :cart_items

  # Root path
  root "home#index"

  # Authentication routes
  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  # User registration
  get "/signup", to: "users#new", as: :signup
  resources :users, only: [ :create, :edit, :update ]

  # Public product browsing
  resources :products, only: [ :index, :show ]

  # Shopping cart
  resource :cart, only: [ :show ], controller: :carts
  resources :cart_items, only: [ :create, :update, :destroy ]

  # Checkout and orders
  get "/checkout", to: "checkouts#new", as: :checkout
  post "/checkout", to: "checkouts#create", as: :checkout
  resources :orders, only: [ :index, :show, :create ]

  # Customer dashboard (optional - can be removed if not used)
  get "/dashboard", to: "customers#dashboard", as: :customer_dashboard

  # Admin routes (Business Owner Dashboard)
  namespace :admin do
    root to: "dashboard#index"
    resources :products, controller: "products"
    resources :orders, only: [ :index, :show, :update ], controller: "orders"
    resources :customers, only: [ :index, :show ], controller: "customers"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes (commented out by default)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
