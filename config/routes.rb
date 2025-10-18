Rails.application.routes.draw do
  resources :order_items
  resources :orders
  resources :cart_items
  resources :carts
  resources :admins
  resources :customers
  resources :products
  resources :users
  resources :roles

  # Root path
  root 'home#index'

  # Authentication routes
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # User registration
  get '/signup', to: 'users#new'
  resources :users, only: [:create, :edit, :update]

  # Product browsing
  resources :products, only: [:index, :show]

  # Shopping cart
  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  # Checkout and orders
  get '/checkout', to: 'checkouts#new'
  post '/checkout', to: 'checkouts#create'
  resources :orders, only: [:index, :show, :create]

  # Customer dashboard
  get '/dashboard', to: 'customers#dashboard'

  # Admin routes
  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :products
    resources :orders, only: [:index, :show, :update]
    resources :customers, only: [:index, :show]
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
