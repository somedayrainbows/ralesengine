Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :merchants do
        get '/:id/items', to: 'items#index', as: 'merchant_items'
        get '/:id/invoices', to: 'invoices#index', as: 'merchant_invoices'
        get '/find', to: 'finder#show'
        get '/find_all', to: 'finder#index'
        get '/random', to: 'random#show'
        get '/:id/revenue', to: 'revenue#show'
        get '/most_items', to: 'most_items#index'
        get '/:id/customers_with_pending_invoices', to: 'customers#index'
        get '/most_revenue', to: 'most_revenue#index'
        get '/:id/favorite_customer', to: 'favorite_customer#show'
      end
      resources :merchants, only: [:index, :show]
      namespace :invoices do
        get '/:id/transactions', to: 'transactions#index', as: 'transactions'
        get '/:id/invoice_items', to: 'invoice_items#index', as: 'invoice_items'
        get '/:id/items', to: 'items#index', as: 'items'
        get '/:id/customer', to: 'customers#show', as: 'customer'
        get '/:id/merchant', to: 'merchants#show', as: 'merchant'
        get '/find', to: 'finder#show'
        get '/find_all', to: 'finder#index'
        get '/random', to: 'random#show'
      end
      resources :invoices, only: [:index, :show]
      namespace :transactions do
        get '/:id/invoice', to: 'invoices#show', as: 'transaction_invoice'
        get '/find', to: 'finder#show'
        get '/find_all', to: 'finder#index'
        get '/random', to: 'random#show'
      end
      resources :transactions, only: [:index, :show]
      namespace :customers do
        get '/:id/invoices', to: 'invoices#index', as: 'customer_invoices'
        get '/:id/transactions', to: 'transactions#index', as: 'customer_transactions'
        get '/:id/favorite_merchant', to: 'favorite_merchant#show'
      end
      resources :customers, only: [:index, :show]
      namespace :items do
        get '/:id/invoice_items', to: 'invoice_items#index', as: 'item_invoice_items'
        get '/:id/merchant', to: 'merchants#show', as: 'item_merchant'
        get '/:id/best_day', to: 'best_day#show'
        get '/most_items', to: 'most_items#index'
        get '/most_revenue', to: 'most_revenue#index'
      end
      resources :items, only: [:index, :show]
      namespace :invoice_items do
        get '/:id/invoice', to: 'invoices#show', as: 'invoice'
        get '/:id/item', to: 'items#show', as: 'item'
      end
      resources :invoice_items, only: [:index, :show]
    end
  end
end
