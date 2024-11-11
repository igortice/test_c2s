Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  root to: proc {
    is_development = Rails.env.development?
    base_text      = "API is running for microservico notificacao"
    base_text      += " </br><a href='/api-docs'>API Docs</a>" if is_development

    [200, { "Content-Type" => "text/html" }, [base_text]]
  }

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :notifications, only: [:create, :update] do
        member do
          get :status
        end
      end
    end
  end
end
