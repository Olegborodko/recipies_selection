Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'#, constraints: ApplicationController.new

  get 'index', to: 'users#index', defaults: { format: 'json' }

  scope "(:locale)", locale: /en|ru/ do
    resources :users, except: [:show]
    get 'signup', to: 'users#new'
    get 'verification/:id', to: 'users#verification', as: :verification
    put 'update_description', to: 'users#update_description', as: :update_description
    get 'restore_password', to: 'users#restore_password', as: :restore_password
    post 'restore', to: 'users#restore'
    get 'switch/:locale', to: 'users#switch', as: :switch
  end

  scope "(:locale)", locale: /en|ru/ do
    namespace :users do
      resources :sessions, only: [:create]
      get 'sessions', to: 'sessions#new'
      get 'login', to: 'sessions#new', as: :login
      delete 'logout/:id', to: 'sessions#destroy', as: :logout
    end
  end

  mount Api => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # resources :ingredient_categories do
  #   resources :ingredients
  # end

  #get '/:locale' => 'users#index'
  scope "(:locale)", locale: /en|ru/ do
    root 'users#index'
    get 'parser', to: 'parser#index', constraints: ApplicationController.new
  end

end
