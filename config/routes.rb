Rails.application.routes.draw do
  require 'sidekiq/web'

  constraints SidekiqAdminConstraint do
    mount Sidekiq::Web => '/sidekiq'
  end
  

  mount ActionCable.server => "/cable"

  root "welcome#index"
  get "customizations.css", to: "customizations#styles", as: :custom_styles, defaults: { format: :css }

  get "login", to: "welcome#login", as: :login
  get "company", to: "welcome#company", as: :company
  get "closed", to: "welcome#closed", as: :closed
  get "faqs", to: "welcome#faqs", as: :faqs
  get "terms", to: "welcome#terms", as: :terms
  get "cart", to: "welcome#cart", as: :cart
  get "order_notifications", to: "welcome#order_notifications", as: :order_notifications

  post "/checkout", to: "checkout#create"
  get "/checkout/success", to: "checkout#success"
  get "/checkout/cancel", to: "checkout#cancel"


  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  get "shop", to: "welcome#shop", as: :shop
  get "sign_out", to: "welcome#sign_out", as: :sign_out

  resources :attendees
  resources :orders, only: :show

  resources :performers, only: :index do
    collection do
      get :pay, as: :pay
      get :status, as: :status
      post :pay
    end
  end

  resources :line_items, only: [ :create, :update, :destroy ]

  resources :vouchers, only: [ :index ]

  namespace :admin do
    get "/", to: "admin#index"
    resources :users, :products, :settings
    resources :line_items, except: [ :index ]

    resources :orders do 
      collection do
        get :reports
      end
    end

    resources :activities, only: [ :index ] do
      collection do
        delete :destroy_all, as: :destroy_all
      end
    end
    
    resources :attendees, :performers do
      collection do
        post "reset_chuds_balance/(:amount)", action: :reset_chuds_balance, as: :reset_chuds_balance
        post "reset_performance_points/(:amount)", action: :reset_performance_points, as: :reset_performance_points
        post "gift_chuds/(:amount)", action: :gift_chuds, as: :gift_chuds
      end
    end

    resources :vouchers do 
      collection do 
        get 'upload', as: :upload
        post 'upload'
      end
    end
  end

  namespace :store do 
    get "/", to: "products#index"
    resources :products, only: :index
    resources :orders, only: :show

    get "/cart", to: "checkout#cart", as: :cart

    post "/checkout", to: "checkout#create"
    post "/empty", to: "checkout#empty", as: :empty
    get "/checkout/success", to: "checkout#success"
    get "/checkout/cancel", to: "checkout#cancel"
    get 'qr/:order_id', to: 'checkout#qr', as: :qr
    post 'new', to: 'checkout#new', as: :new_cart
    post 'new', to: 'checkout#new', as: :pay_cash
  end

  namespace :api do
    get "/", to: "api#index"
    post "show/:start_or_stop", to: "api#show"
    post "checkpoint/:start_or_stop", to: "api#checkpoint"
    post "show_code/:code", to: "api#show_code"
    post "/webhooks/stripe", to: "webhooks#stripe"

    resources :settings, only: [ :show, :update ]
    resources :products, only: [ :show, :update ]

    resources :performers, only: [ :index, :show ] do
      member do
        post "reset_chuds_balance/:amount", action: :reset_chuds_balance
        post "reset_performance_points/:amount", action: :reset_performance_points
        post "gift_chuds/:amount", action: :gift_chuds
        post "gift_performance_points/:amount", action: :gift_performance_points
      end

      collection do
        post "reset_chuds_balance/:amount", action: :reset_chuds_balance
        post "reset_performance_points/:amount", action: :reset_performance_points
        post "gift_chuds/:amount", action: :gift_chuds
        post "gift_performance_points/:amount", action: :gift_performance_points
      end
    end

    namespace "attendees" do
      post "reset_chuds_balance/(:amount)", action: :reset_chuds_balance
      post "reset_performance_points/(:amount)", action: :reset_performance_points
      post "gift_chuds/(:amount)", action: :gift_chuds
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

  direct :rails_public_blob do |blob|
    # Preserve the behaviour of `rails_blob_url` inside these environments
    # where S3 or the CDN might not be configured
    if ENV.fetch("ACTIVE_STORAGE_ASSET_HOST", false) && blob&.key
     File.join(ENV.fetch("ACTIVE_STORAGE_ASSET_HOST"), blob.key)
    else
     route =
        # ActiveStorage::VariantWithRecord was introduced in Rails 6.1
       # Remove the second check if you're using an older version
       if blob.is_a?(ActiveStorage::Variant) || blob.is_a?(ActiveStorage::VariantWithRecord)
          :rails_representation
       else
          :rails_blob
       end
     route_for(route, blob)
    end
  end
end
