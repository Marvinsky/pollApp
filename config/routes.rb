Rails.application.routes.draw do
  get 'sessions/create'

  get 'welcome/index'

  get 'welcome/app'

  namespace :api, defaults: {format: "json"} do
    namespace :v1 do
      resources :users, only: [:create]
      resources :polls, controller: "my_polls", except: [:new, :edit] do
        resources :questions, except: [:new, :edit]
        resources :answers, only: [:update, :destroy, :create]
      end
      match "*unmatched", via: [:options], to: "master_api#xhr_options_request"
    end
    namespace :v2 do
      resources :users
    end
  end

  get "/", to: "welcome#index"

  get "/auth/google_oauth2/callback", to: "sessions#create"

end