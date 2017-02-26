Rails.application.routes.draw do

  # resources :ingredients
  # resources :ingredient_categories

  root 'users#index'
  get 'verification', to: 'users#verification', as: :verification

  resources :users
  resources :sessions, only: [:new, :create, :destroy]

  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'parser' => 'parser#index'
  resources :ingredient_categories do
    resources :ingredients
  end

end
