class Api < Grape::API
  prefix 'api'
  # version 'v1'
  format :json

  mount Modules::Users
  mount Modules::CategoriesOfIngredients

end