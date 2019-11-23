Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/merchants/find_all', to: 'merchants#index'
      get '/merchants/find', to: 'merchants#show'
      get '/merchants/random', to: 'merchants#random'
      get '/merchants/most_revenue', to: 'merchants#most_revenue'
      get '/merchants/:merchant_id/items', to: 'merchants/items#index'
      get '/merchants/:merchant_id/invoices', to: 'merchants/invoices#index'
      get '/merchants/revenue', to: 'merchants#date_revenue'
      get '/merchants/:id/favorite_customer', to: 'merchants#favorite_customer'
      resources :merchants, only: [:index, :show]
    end
  end
end
