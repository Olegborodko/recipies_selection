class Api < Grape::API
  prefix 'api'
  # version 'v1'
  format :json
  mount Modules::CategoriesOfIngredients
  mount Modules::Components

  add_swagger_documentation :add_version => true,
                            :base_path => '/'
end