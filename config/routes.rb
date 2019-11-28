Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      get '/merchants/find_all', to: 'merchants/find#index'
      get '/merchants/find', to: 'merchants/find#show'
      get '/merchants/random', to: 'merchants/random#show'
      get '/merchants/most_revenue', to: 'merchants#most_revenue'
      get '/merchants/:merchant_id/items', to: 'merchants/items#index'
      get '/merchants/:merchant_id/invoices', to: 'merchants/invoices#index'
      get '/merchants/revenue', to: 'merchants#date_revenue'
      get '/merchants/:id/favorite_customer', to: 'merchants#favorite_customer'
      resources :merchants, only: [:index, :show]

      get '/items/find', to: 'items/find#show'
      get '/items/find_all', to: 'items/find#index'
      get '/items/random', to: 'items/random#show'
      get '/items/:item_id/merchant', to: 'items/merchants#show'
      get '/items/:item_id/invoice_items', to: 'items/invoice_items#index'
      resources :items, only: [:index, :show]

      get '/customers/find', to: 'customers/find#show'
      get '/customers/find_all', to: 'customers/find#index'
      get '/customers/random', to: 'customers/random#show'
      resources :customers, only: [:index, :show]
    end
  end
end
