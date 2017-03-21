module Modules
  class CategoriesOfIngredients < Grape::API
    prefix :api
    format :json

    desc 'Ingredients controller'
    resource :categories_of_ingredients do
      desc 'All categories'

      #/api/categories_of_ingredients
      get do
        categories_of_ingredients = IngredientCategory.all
        present categories_of_ingredients, with: Api::Entities::CategoryOfIngredients
      end

      desc 'Current category'
      #/api/categories_of_ingredients/id
      get ':id' do
        {category_of_ingredients_id: params[:id]}
      end

      #/api/categories_of_ingredients
      params do
        requires :category_of_ingredients, type: Hash do
          requires :title, type: String
        end
      end

      desc 'Create new category'
      post do
        category_of_ingredients = IngredientCategory.new(
            declared(params, include_missing: false)[:category_of_ingredients])
        category_of_ingredients.save
        present category_of_ingredients, with: Api::Entities::CategoryOfIngredients
      end

      desc 'Update category'
      put ':id' do
        IngredientCategory.find(params[:id])
            .update({title: params[:category_of_ingredients]})
      end

      desc 'Delete category'
      delete ':id' do
        IngredientCategory.find(params[:id]).destroy
      end
    end
  end
end