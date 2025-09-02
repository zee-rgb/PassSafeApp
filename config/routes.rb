Rails.application.routes.draw do
  devise_for :users, path: "secure"

  root "pages#home"

  get "/home", to: "pages#home"
  get "/about", to: "pages#about"

  resources :entries
end
