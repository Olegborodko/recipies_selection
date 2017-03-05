Rails.application.routes.draw do

  # resources :ingredients
  # resources :ingredient_categories

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'users#index'

  resources :users, except: [:show]
  get 'signup', to: 'users#new'
  get 'verification/:id', to: 'users#verification', as: :verification
  put 'update_description', to: 'users#update_description', as: :update_description
  get 'restore_password', to: 'users#restore_password', as: :restore_password
  post 'restore', to: 'users#restore'

  namespace :users do
    resources :sessions, only: [:create]
    get 'sessions', to: 'sessions#new'
    get 'login', to: 'sessions#new', as: :login
    get 'logout', to: 'sessions#destroy', as: :logout
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'parser' => 'parser#index'
  resources :ingredient_categories do
    resources :ingredients
  end

end
