Rails.application.routes.draw do
  # Devise authentication routes
  devise_for :users

  # Tasks routes
  resources :tasks do
    member do
      patch :mark_complete
    end
  end

  # Root and dashboard
  root to: "dashboard#index"
  get "dashboard", to: "dashboard#index"

  # Admin namespace
  namespace :admin do
    resources :users, only: [:index, :edit, :update, :destroy] do
      collection do
        post :invite_manager
      end
    end

    resources :tasks, only: [:index, :show]  # ← Add this line
    root to: "users#index"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
