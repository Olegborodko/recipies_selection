module Modules
  class CategoriesOfRecipes < Grape::API
    prefix :api
    format :json

    resource :categories_of_recipes do
      desc 'All categories'

      #/api/categories_of_recipes
      get do
        categories_of_recipes = RecipeCategory.all
        present categories_of_recipes, with: Api::Entities::CategoryOfRecipes
      end

      desc 'Current category'
      #/api/categories_of_recipes/id
      get ':id' do
        {category_of_recipes_id: params[:id]}
      end

      #/api/categories_of_recipes
      params do
        requires :category_of_recipes, type: Hash do
          requires :title, type: String
        end
      end

      desc 'Create new category'
      post do
        category_of_recipes = RecipeCategory.new(
            declared(params, include_missing: false)[:category_of_recipes])
        category_of_recipes.save
        present category_of_recipes, with: Api::Entities::CategoryOfRecipes
      end

      desc 'Update category'
      put ':id' do
        RecipeCategory.find(params[:id])
            .update({title: params[:category_of_recipes]})
      end

      desc 'Delete category'
      delete ':id' do
        RecipeCategory.find(params[:id]).destroy
      end
    end
  end
end