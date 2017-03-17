Rails.application.routes.draw do
  # resources :ingredients
  # resources :ingredient_categories
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq', constraints: ApplicationController.new

  root 'users#index'
  get 'index' => 'users#index', :defaults => { :format => 'json' }

  resources :users, except: [:show]
  get 'signup' => 'users#new'
  get 'verification/:id' => 'users#verification', as: :verification
  put 'update_description' => 'users#update_description', as: :update_description
  get 'restore_password' => 'users#restore_password', as: :restore_password
  post 'restore' => 'users#restore'

  namespace :users do
    resources :sessions, only: [:create]
    get 'sessions' => 'sessions#new'
    get 'login' => 'sessions#new', as: :login
    delete 'logout/:id' => 'sessions#destroy', as: :logout
  end

  mount UsersApi::ApiUsersController => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'parser' => 'parser#index'
  resources :ingredient_categories do
    resources :ingredients
  end

end
