Rails.application.routes.draw do

  # resources :ingredients
  # resources :ingredient_categories

  root 'users#index'
  get 'mail', to: 'users#mail', as: :users_mail

  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'parser' => 'parser#index'
  resources :ingredient_categories do
    resources :ingredients
  end

end
