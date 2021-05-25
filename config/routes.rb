Rails.application.routes.draw do
  get 'home/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'home#index'

  namespace :api do
    namespace :v1 do
      get '/users/:id', to: 'users#show'
    end
  end
end
