Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root "welcome#index"
  get "login", to: "welcome#login", as: :login
  get "company", to: "welcome#company", as: :company
  get "product", to: "welcome#product", as: :product
  get "closed", to: "welcome#closed", as: :closed

  devise_for :users

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
    resources :attendees, :performers,
              :users, :vouchers, :products,
              :settings
    get "/", to: "admin#index"
  end

  namespace :api do
    get "/", to: "api#index"
    post "chuds/buy", to: "chuds#buy"
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
