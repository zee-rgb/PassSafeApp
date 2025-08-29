Rails.application.routes.draw do
  devise_for :users
  # Defines the root path route ("/")
  root "pages#home"

  get "/home", to: "pages#home"
  get "/about", to: "pages#about"
end
