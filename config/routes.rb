Rails.application.routes.draw do
  # Devise authentication routes (login, signup, etc.)
  devise_for :users

  # Root and dashboard
  root to: "dashboard#index"
  get "dashboard", to: "dashboard#index"   # optional alias, you can keep or remove

  # Admin namespace – keep everything admin-related here
  namespace :admin do
    resources :users, only: [:index, :edit, :update, :destroy] do
      # Custom collection route for inviting managers (POST /admin/users/invite_manager)
      collection do
        post :invite_manager
      end
    end

    # Optional: shortcut to admin dashboard/users list
    get "/", to: "users#index", as: :root   # → /admin → admin/users#index
  end

  # Health check (good to keep)
  get "up" => "rails/health#show", as: :rails_health_check

  # PWA routes (uncomment if you actually use them)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end