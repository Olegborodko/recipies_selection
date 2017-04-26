class Api < Grape::API
  prefix 'api'
  # version 'v1'
  format :json

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    error!({status: :error, message: :not_found}, 404)
  end

  mount Modules::UsersPart
  mount Modules::Admin
  mount Modules::FavoriteRecipes
  mount Modules::CategoriesOfIngredients
  mount Modules::CategoriesOfRecipes
  mount Modules::Components
  mount Modules::Receipts

  add_swagger_documentation add_version: true,
                            base_path: '/'
end