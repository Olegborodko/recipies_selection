Rails.application.routes.draw do
  root 'users#index'

  get 'mail', to: 'users#mail', as: :users_mail
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
