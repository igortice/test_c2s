Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "index#index"

  # Rotas de Autenticação
  get "auth/login_form"
  get "/register", to: "auth#new", as: "register"
  post "/register", to: "auth#create"
  post "/login", to: "auth#login"
  get "/logout", to: "auth#logout", as: "logout"

  # Rotas de Tarefas
  resources :tasks do
    collection do
      post :notification_callback
    end
  end
end
