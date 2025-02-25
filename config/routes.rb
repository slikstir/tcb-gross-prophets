Rails.application.routes.draw do
  mount ActionCable.server => "/cable"

  root "welcome#index"
  get "login", to: "welcome#login", as: :login
  get "company", to: "welcome#company", as: :company
  get "product", to: "welcome#product", as: :product
  get "closed", to: "welcome#closed", as: :closed

  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  get "shop", to: "welcome#shop", as: :shop
  get "sign_out", to: "welcome#sign_out", as: :sign_out

  resources :attendees
  resources :performers, only: :index do
    collection do
      get :status
      get :vote, as: :vote
      post :vote
      get :pay, as: :pay
      post :pay
    end
  end
  resources :vouchers, only: [ :index ]

  namespace :admin do
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
    resources :users, :vouchers, :products,
              :settings
    get "/", to: "admin#index"
  end

  namespace :api do
    get "/", to: "api#index"
    post "chuds/buy", to: "chuds#buy"
    post "show/:start_or_stop", to: "api#show"
    post "checkpoint/:start_or_stop", to: "api#checkpoint"
    post "show_code/:code", to: "api#show_code"

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
end
