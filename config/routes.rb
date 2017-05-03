Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :merchants, only: [:index, :show]
      namespace :merchants, only: [:index, :show] do
        get '/:id/items', to: 'items#index', as: 'api_v1_merchant_items'
        get '/:id/invoices', to: 'invoices#index', as: 'api_v1_merchant_invoices'
      end
      resources :invoices, only: [:index, :show]
      resources :transactions, only: [:index, :show]
      resources :customers, only: [:index, :show]
      resources :items, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
    end
  end
end
