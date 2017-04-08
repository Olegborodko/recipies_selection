Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'#, constraints: ApplicationController.new

  get 'index' => 'users#index', :defaults => { :format => 'json' }

  scope "(:locale)", locale: /en|ru/ do
    resources :users, except: [:show]
    get 'signup' => 'users#new'
    get 'verification/:id' => 'users#verification', as: :verification
    put 'update_description' => 'users#update_description', as: :update_description
    get 'restore_password' => 'users#restore_password', as: :restore_password
    post 'restore' => 'users#restore'
    get 'switch/:locale' => 'users#switch', as: :switch
  end

  scope "(:locale)", locale: /en|ru/ do
    namespace :users do
      resources :sessions, only: [:create]
      get 'sessions' => 'sessions#new'
      get 'login' => 'sessions#new', as: :login
      delete 'logout/:id' => 'sessions#destroy', as: :logout
    end
  end

  mount Api => '/'
  mount GrapeSwaggerRails::Engine => '/swagger'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'parser' => 'parser#index'
  # resources :ingredient_categories do
  #   resources :ingredients
  # end

  #get '/:locale' => 'users#index'
  scope "(:locale)", locale: /en|ru/ do
    root 'users#index'
  end

end
