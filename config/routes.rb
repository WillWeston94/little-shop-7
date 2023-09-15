Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/merchants/:merchant_id/dashboard", to: "merchants#show"
  get "/merchants/:merchant_id/items", to: "merchant_items#index"
  get "/merchants/:merchant_id/items/:item_id", to: "merchant_items#show"


  namespace :admin, path: '/admin' do
    get '', to: 'dashboard#index', as: 'dashboard'

    resources :merchants do
      member do
        put :disable_enable, to: "merchants#disable_enable", as: :disable_enable
      end
    end
    
    resources :invoices, only: [:show]
  end

  get "/admin/invoices", to: "admin/invoices#index"
  get "/admin/invoices/:id", to: "admin/invoices#show"
end

