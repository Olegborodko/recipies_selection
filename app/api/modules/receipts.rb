module Modules
  class Receipts < Grape::API
    prefix :api
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    desc 'Receipt controller'
    namespace :search do
      desc 'Search'
      params do
        requires :query, type: String
      end
      get do
        receipts = Recipe.includes(:ingredients, :recipe_ingredients).search(params[:query])
        present receipts, with: Api::Entities::Receipt
      end
    end

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
        requires :ingredient_id, type: Array(Integer), coerce_with: ->(val) do
          val.split(/\, /).map(&:to_s)
        end,
                 desc: 'Array of ingredient'
        requires :number_of_ingredient, type: Array(String), coerce_with: ->(val) do
          val.split(/\, /).map(&:to_s)
        end,
                 desc: 'Array of number of each ingredient'
      end
      post do
        if user_admin? @current_user
          ingredient = Ingredient.find(params[:ingredient_id])
          receipt = set_rec_category.recipes.build(
            recipe_category_id: params[:recipe_category_id],
            name: params[:name],
            content: params[:content],
            cooking_time: params[:cooking_time],
            calories: params[:calories],
            protein: params[:protein],
            fat: params[:fat],
            carbohydrate: params[:carbohydrate])

          receipt.ingredients << ingredient

          if receipt.save
            ri_all = receipt.recipe_ingredients
            x = 0
            ri_all.each_with_object({}) do |ri, obj|
              obj[ri.ingredient.name] = ri.number_of_ingredient
              ri.number_of_ingredient = params[:number_of_ingredient][x]
              x += 1
              ri.save
            end
            present receipt, with: Api::Entities::Receipt
            { status: :success }
          else
            error!(status: :error, message: receipt.errors.full_messages.first) if receipt.errors.any?
          end
        else
          { error: 'not authorized' }
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
        optional :ingredient_id, type: Array(Integer), coerce_with: ->(val) do
          val.split(/\, /).map(&:to_s)
        end,
                 desc: 'Array of ingredient'
        optional :number_of_ingredient, type: Array(String), coerce_with: ->(val) do
          val.split(/\, /).map(&:to_s)
        end,
                 desc: 'Array of number of each ingredient'
      end
      put ':id' do
        if user_admin? @current_user
          receipt = set_rec_category.recipes.find(params[:id])
          if receipt.update(
            recipe_category_id: params[:recipe_category_id],
            name: params[:name],
            content: params[:content],
            cooking_time: params[:cooking_time],
            calories: params[:calories],
            protein: params[:protein],
            fat: params[:fat],
            carbohydrate: params[:carbohydrate])

            ri_all = receipt.recipe_ingredients
            x = params[:ingredient_id].size
            ri_all.where(ingredient_id: params[:ingredient_id]).each_with_object({}) do |ri, obj|
              x -= 1
              ri.number_of_ingredient = params[:number_of_ingredient][x]
              ri.save
            end
            present receipt, with: Api::Entities::Receipt
            { status: :success }
          else
            error!(status: :error, message: receipt.errors.full_messages.first) if receipt.errors.any?
          end
        else
          { error: 'not authorized' }
        end
      end

      desc 'Delete receipt'
      params do
        requires :id, type: Integer, desc: 'Recipe id'
      end
      delete ':id' do
        if user_admin? @current_user
          receipt = Recipe.find(params[:id])
          { status: :success } if receipt.recipe_ingredients.destroy_all && receipt.delete
        else
          { error: 'not authorized' }
        end
      end
    end
  end
end