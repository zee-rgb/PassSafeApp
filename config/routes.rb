Rails.application.routes.draw do
  scope "(:locale)", locale: /en|es|fr|pt|id|zh|ja/ do
    devise_for :users, path: "secure"

    root "entries#index"
    get "/home", to: "pages#home"
    get "/about", to: "pages#about"
    get "/privacy", to: "pages#privacy"
    get "/terms", to: "pages#terms"
    get "/security", to: "pages#security"
    get "/help", to: "pages#help"

    resources :entries do
      member do
        post :reveal_username
        post :reveal_password
        post :mask_username
        post :mask_password
      end
    end
  end
end
