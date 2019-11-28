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
      get '/customers/:id/invoices', to: 'customers/invoices#index'
      get '/customers/:id/transactions', to: 'customers/transactions#index'
      resources :customers, only: [:index, :show]

      get '/invoices/find', to: 'invoices/find#show'
      get '/invoices/find_all', to: 'invoices/find#index'
      get '/invoices/random', to: 'invoices/random#show'
      resources :invoices, only: [:index, :show]

      get 'transactions/find', to: 'transactions/find#show'
      get 'transactions/find_all', to: 'transactions/find#index'
      get 'transactions/random', to: 'transactions/random#show'
      resources :transactions, only: [:index, :show]
    end
  end
end
