class Api < Grape::API
  prefix 'api'
  # version 'v1'
  format :json

  mount Modules::UsersPart
  mount Modules::CategoriesOfIngredients
  mount Modules::CategoriesOfRecipes
  mount Modules::Components
  mount Modules::Receipts

  add_swagger_documentation :add_version => true,
                            :base_path => '/'
end