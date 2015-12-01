Rails.application.routes.draw do
  get "/", to: "welcome#index"

  namespace :api do
    namespace :v1 do
      resources :users
    end
    namespace :v2 do
      resources :users
    end
  end
end