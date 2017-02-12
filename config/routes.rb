Rails.application.routes.draw do
  # resources :ingredients
  # resources :ingredient_categories
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/'=>'parser#index'
  resources :ingredient_categories do
    resources :ingredients
  end

end
