module Modules
  class Receipts < Grape::API
    prefix :api
    format :json

    helpers do
      include SessionHelper
      include UserHelpers
    end

    before do
      @current_user = get_user_from_token(users_token)
    end

    desc 'Receipt controller'

    namespace :search do
      desc 'Search'
      params do
        requires :query, type: String
      end
      get do
        receipts = Recipe.search(params[:query])
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
        requires :ingredient_category_id, type: Integer
        requires :ingredient_id, type: Integer
        requires :number_of_ingredient, type: String
      end
      post do
        return { error: 'not authorized' } if !user_admin? @current_user
        ingredient = set_ing_category.ingredients.find(params[:ingredient_id])
        receipt = set_rec_category.recipes.find_or_create_by(
          recipe_category_id: params[:recipe_category_id],
          name: params[:name],
          content: params[:content],
          cooking_time: params[:cooking_time],
          calories: params[:calories],
          protein: params[:protein],
          fat: params[:fat],
          carbohydrate: params[:carbohydrate])

        receipt.ingredients << ingredient
        ri_all = receipt.recipe_ingredients
        ri_all.each_with_object({}) do |ri, obj|
          obj[ri.ingredient.name] = ri.number_of_ingredient
          ri.number_of_ingredient = params[:number_of_ingredient]
          ri.save!
        end

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
        optional :ingredient_category_id, type: Integer
        optional :ingredient_id, type: Integer
        optional :number_of_ingredient, type: String
      end
      put ':id' do
        return { error: 'not authorized' } if !user_admin? @current_user
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

          ni = 0
          unless ni > receipt.recipe_ingredients.size
            ri_all = receipt.recipe_ingredients[ni]
            # ri_all.each_with_object({}) do |ri, obj|
            #   obj[ri.ingredient.name] = ri.number_of_ingredient
            #   ri.number_of_ingredient = params[:number_of_ingredient]
            #   ri.save!
            #   ni += 1
            # end
            ri_all.number_of_ingredient = params[:number_of_ingredient]
            ri_all.save!
            ni += 1
          end
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
        return { error: 'not authorized' } if !user_admin? @current_user
        receipt = Recipe.find(params[:id])
        { status: :success } if receipt.delete
      end
      # end
    end
  end
end