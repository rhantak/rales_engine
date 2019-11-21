Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/merchants/find_all', to: 'merchants#index'
      get '/merchants/find', to: 'merchants#show'
      get '/merchants/random', to: 'merchants#random'
      resources :merchants, only: [:index, :show]
    end
  end
end
