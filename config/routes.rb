Rails.application.routes.draw do
  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'home#index'

  namespace :api do
    namespace :v1 do
      post '/users/new', to: 'users#create'
      get '/users/:id', to: 'users#show'
      put '/users/:id', to: 'users#update'
      delete '/users/:id', to: 'users#destroy'

      post '/users/:user_id/favorites/new', to: 'favorites#create'
      delete '/users/:user_id/favorites/:id', to: 'favorites#destroy'

      post '/auth/login', to: 'auth#login'
    end
  end
end
