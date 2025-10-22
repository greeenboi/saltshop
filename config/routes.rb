Rails.application.routes.draw do
  # Resources that aren't directly accessible (used internally)
  resources :order_items, only: [ :create, :update, :destroy ]

  # Root path
  root "home#index"

  # Authentication routes
  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout

  get "/signup", to: "users#new", as: :signup
  resources :users, only: [ :create, :edit, :update ]

  # Public product browsing and management
  resources :products

  # Shopping cart
  resource :cart, only: [ :show ], controller: :carts
  resources :cart_items, only: [ :create, :update, :destroy ]

  # Checkout and orders
  get "/checkout", to: "checkouts#new", as: :new_checkout
  post "/checkout", to: "checkouts#create", as: :checkout
  resources :orders, only: [ :index, :show, :create ]

  # Customer dashboard (optional - can be removed if not used)
  get "/dashboard", to: "customers#dashboard", as: :customer_dashboard

  # Admin CRUD for tests
  resources :admins

  # Admin routes (Business Owner Dashboard)
  scope module: :admin, path: "/admin", as: :admin do
    root to: "dashboard#index"
    resources :products
    resources :orders, only: [ :index, :show, :update ]
    resources :customers, only: [ :index, :show ]
  end

  # Health check
  get "up" => "rails/health#show", :as => :rails_health_check

  # PWA routes (commented out by default)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
