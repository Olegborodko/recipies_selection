Rails.application.routes.draw do

  # resources :ingredients
  # resources :ingredient_categories

  root 'users#index'

  resources :users
  get 'signup', to: 'users#new'
  get 'verification/:id', to: 'users#verification', as: :verification

  namespace :users do
    resources :sessions, only: [:new, :create, :destroy]
    get 'login', to: 'sessions#new'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'parser' => 'parser#index'
  resources :ingredient_categories do
    resources :ingredients
  end

end
