module Modules
  class Receipts < Grape::API
    prefix :api
    format :json

    desc 'Receipt controller'
    # namespace 'categories_of_recipes/:category_of_recipes_id' do
    resource :recipes do

      helpers do
        def set_category
          RecipeCategory.find(params[:recipe_category_id])
        end
      end

      desc 'All recipes in current category'
      params do
        requires :recipe_category_id, type: Integer
      end
      get do
        receipts = set_category.recipes
        present receipts, with: Api::Entities::Receipt
      end

      desc 'Current recipe in current category'
      params do
        requires :recipe_category_id, type: Integer
      end
      get ':id' do
        receipt = set_category.recipes.find(params[:id])
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
        # requires :components, type Hash do
        #   requires
        # end
      end
      post do
        receipt = set_category.recipes.create(declared(params, include_missing: false).to_hash)
        if receipt.save
          present receipt, with: Api::Entities::Receipt
          {status: :success}
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
        receipt = set_category.recipes.find(params[:id])
        if receipt.update(declared(params, include_missing: false).to_hash)
          present receipt, with: Api::Entities::Receipt
          {status: :success}
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
        {status: :success} if receipt.delete
      end
      # end
    end
  end
end