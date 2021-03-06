Rails.application.routes.draw do

  get 'dashboards/index'

  get 'admin/index', as: 'admin'

  root 'store#index', as: 'store_index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :carts
  resources :buyers
  resources :foods
  resources :line_items
  resources :categories
  resources :orders
  # resources :users
  resources :vouchers
  resources :tags
  resources :restaurants
  # resources :reviews

  # Polymorphic
  resources :foods do
    resources :reviews
  end
  resources :restaurants do
    resources :reviews
  end

  resources :users do
    member do
      get 'order_history'
      get 'topup'
      patch 'topup' => 'users#set_topup'
    end
  end

  # get 'home/hello'
  # get 'home/goodbye'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
