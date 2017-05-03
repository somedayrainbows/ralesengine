Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :merchants, only: [:index, :show]
      namespace :merchants, only: [:index, :show] do
        get '/:id/items', to: 'items#index', as: 'merchant_items'
        get '/:id/invoices', to: 'invoices#index', as: 'merchant_invoices'
      end
      resources :invoices, only: [:index, :show]
      namespace :invoices do
        get '/:id/transactions', to: 'transactions#index', as: 'transactions'
        get '/:id/invoice_items', to: 'invoice_items#index', as: 'invoice_items'
        get '/:id/items', to: 'items#index', as: 'items'
        get '/:id/customer', to: 'customers#show', as: 'customer'
        get '/:id/merchant', to: 'merchants#show', as: 'merchant'
      end
      resources :transactions, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :items, only: [:index, :show]
      namespace :items do
        get '/:id/invoice_items', to: 'invoice_items#index', as: 'item_invoice_items'
        get '/:id/merchant', to: 'merchants#show', as: 'item_merchant'
      end
      resources :invoice_items, only: [:index, :show]
      namespace :invoice_items do
        get '/:id/invoice', to: 'invoices#show', as: 'invoice'
        get '/:id/item', to: 'items#show', as: 'item'
      end
    end
  end
end
