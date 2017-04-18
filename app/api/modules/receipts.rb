module Modules
  class Receipts < Grape::API
    prefix :api
    format :json

    desc 'Receipt controller'
    resource :recipes do

      helpers do
        def set_rec_category
          RecipeCategory.find(params[:recipe_category_id])
        end

        def set_ing_category
          IngredientCategory.find(params[:ingredient_category_id])
        end
      end

      desc 'All recipes in current category'
      params do
        requires :recipe_category_id, type: Integer
      end
      get do
        receipts = set_rec_category.recipes
        present receipts, with: Api::Entities::Receipt
      end

      desc 'Current recipe in current category'
      params do
        requires :recipe_category_id, type: Integer
      end
      get ':id' do
        receipt = set_rec_category.recipes.find(params[:id])
        present receipt, with: Api::Entities::Receipt
      end

      desc 'Create new receipt'
      params do
        requires :recipe_category_id, type: Integer
        requires :name, type: String
        requires :content, type: String
        requires :cooking_time, type: String
        requires :calories, type: Integer
        requires :protein, type: Integer
        requires :fat, type: Integer
        requires :carbohydrate, type: Integer
        requires :ingredients, type: Hash do
          requires :ingredient, type: String
          requires :number_of_ingredient, type: String
        end
      end
      post do
        ingredient = set_rec_category.ingredients.find(params[:ingredient])
        receipt = set_rec_category.recipes.create(declared(params, include_missing: false).to_hash)
        receipt.ingredients << ingredient
        ri = receipt.recipe_ingredients[ingredient]
        ri.number_of_ingredient = params[:number_of_ingredient]
        ri.save!
        if receipt.save
          present receipt, with: Api::Entities::Receipt
          { status: :success }
        else
          error!(status: :error, message: receipt.errors.full_messages.first) if receipt.errors.any?
        end
      end

      desc 'Update receipt'
      params do
        requires :recipe_category_id, type: Integer
        optional :name, type: String
        optional :content, type: String
        optional :cooking_time, type: String
        optional :calories, type: Integer
        optional :protein, type: Integer
        optional :fat, type: Integer
        optional :carbohydrate, type: Integer
      end
      put ':id' do
        receipt = set_rec_category.recipes.find(params[:id])
        if receipt.update(declared(params, include_missing: false).to_hash)
          present receipt, with: Api::Entities::Receipt
          { status: :success }
        else
          error!(status: :error, message: receipt.errors.full_messages.first) if receipt.errors.any?
        end
      end

      desc 'Delete receipt'
      params do
        requires :recipe_category_id, type: Integer
      end
      delete ':id' do
        receipt = Recipe.find(params[:id])
        { status: :success } if receipt.delete
      end
      # end
    end
  end
end