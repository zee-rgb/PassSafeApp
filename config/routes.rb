Rails.application.routes.draw do
  # Development-only diagnostic routes
  if Rails.env.development?
    get "diagnostic/encryption_keys"
  end

  # Temporary database fix route - REMOVE AFTER USE
  get "database_fix/solid_cache", to: "database_fix#fix_solid_cache"

  scope "(:locale)", locale: /en|es|fr|pt|id|zh|ja/ do
    devise_for :users, path: "secure", controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions"
    }

    # Two-step account deletion confirmation page
    devise_scope :user do
      get "/secure/confirm_delete", to: "users/registrations#confirm_delete", as: :confirm_delete
    end

    # Authenticated users land on entries, unauthenticated see a public home page
    authenticated :user do
      root "entries#index", as: :authenticated_root
    end
    unauthenticated do
      root "pages#home", as: :unauthenticated_root
    end
    # Fallback root to provide root_path helper for URL generation
    root "pages#home"
    get "/home", to: "pages#home"
    get "/about", to: "pages#about"
    get "/privacy", to: "pages#privacy"
    get "/terms", to: "pages#terms"
    get "/security", to: "pages#security"
    get "/help", to: "pages#help"

    resources :entries do
      member do
        get :confirm_delete
        post :reveal_username
        post :reveal_password
        post :mask_username
        post :mask_password
      end
    end
  end
end
