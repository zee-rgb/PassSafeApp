Rails.application.routes.draw do
  scope "(:locale)", locale: /en|es|fr|pt|id|zh|ja/ do
    devise_for :users, path: "secure"

    root "entries#index"

    get "/home", to: "pages#home"
    get "/about", to: "pages#about"

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
