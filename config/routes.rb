Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "pages#home"

  get "/home", to: "pages#home"
  get "/about", to: "pages#about"
end
