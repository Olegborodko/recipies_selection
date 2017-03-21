class Api < Grape::API
  prefix 'api'
  # version 'v1'
  format :json

  mount Modules::UsersApi
  mount Modules::CategoriesOfIngredients

end