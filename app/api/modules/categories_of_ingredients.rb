module Modules
  class CategoriesOfIngredients < Grape::API
    prefix :api
    format :json

    desc 'Ingredients controller'
    resource :categories_of_ingredients do
      desc 'All categories'

      #/api/v1/categories_of_ingredients
      get do
        categories_of_ingredients = IngredientCategory.all
        # {categories_of_ingredients: categories_of_ingredients}
        present categories_of_ingredients, with: Api::Entities::CategoryOfIngredients
      end

      #/api/v1/categories_of_ingredients/id
      get ':id' do
        { category_of_ingredients_id: params[:id] }
      end

      #/api/v1/categories_of_ingredients
      params do
        requires :category_of_ingredients, type: Hash do
          requires :title, type: String
        end
      end

      post do
        category_of_ingredients = IngredientCategory.new(declared(params[:category_of_ingredients]))
        category_of_ingredients.save
        present category_of_ingredients, with: Api::Entities::CategoryOfIngredients

        # { category_of_ingredients: category_of_ingredients }
      end



      add_swagger_documentation :add_version => true,
                                :base_path => '/api'
    end
  end
end