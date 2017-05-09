class Api < Grape::API
  prefix 'api'
  # version 'v1'
  format :json

  rescue_from ActiveRecord::RecordNotFound do |_exception|
    error!({ status: :error, message: :not_found }, 404)
  end

  group do
    before do
      @current_user = get_user_from_token(users_token)
    end
    mount Modules::CategoriesOfIngredients
    mount Modules::CategoriesOfRecipes
    mount Modules::Components
    mount Modules::Receipts
  end
  mount Modules::UsersPart
  mount Modules::Admin
  mount Modules::FavoriteRecipes

  add_swagger_documentation add_version: true,
                            base_path: '/'
end