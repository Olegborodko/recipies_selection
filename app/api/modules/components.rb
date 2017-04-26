module Modules
  class Components < Grape::API
    prefix :api
    format :json

    helpers do
      def set_ing_category
        IngredientCategory.find(params[:ingredient_category_id])
      end

      include SessionHelper
      include UserHelpers
    end

    before do
      @current_user = get_user_from_token(users_token)
    end

    desc 'Ingredients controller'
    resource :ingredients do


      desc 'All ingredients in current category'
      params do
        requires :ingredient_category_id, type: Integer
      end
      get do
        components = set_ing_category.ingredients
        present components, with: Api::Entities::Component
      end

      desc 'Current ingredient in current category'
      params do
        requires :ingredient_category_id, type: Integer
      end
      get ':id' do
        component = set_ing_category.ingredients.find(params[:id])
        present component, with: Api::Entities::Component
      end

      desc 'Create new component'
      params do
        requires :ingredient_category_id, type: Integer
        requires :name, type: String
        requires :content, type: String
        requires :href, type: String
        requires :calories, type: Integer
        requires :protein, type: Integer
        requires :fat, type: Integer
        requires :carbohydrate, type: Integer
      end
      post do
        return { error: 'not authorized' } if !user_admin? @current_user
        component = set_ing_category.ingredients.create(declared(params, include_missing: false).to_hash)
        if component.save
          present component, with: Api::Entities::Component
          {status: :success}
        else
          error!(status: :error, message: component.errors.full_messages.first) if component.errors.any?
        end
      end

      desc 'Update ingredient'
      params do
        requires :ingredient_category_id, type: Integer
        optional :name, type: String
        optional :content, type: String
        optional :href, type: String
        optional :calories, type: Integer
        optional :protein, type: Integer
        optional :fat, type: Integer
        optional :carbohydrate, type: Integer
      end
      put ':id' do
        return { error: 'not authorized' } if !user_admin? @current_user
        component = set_ing_category.ingredients.find(params[:id])
        if component.update(declared(params, include_missing: false).to_hash)
          {status: :success}
        else
          error!(status: :error, message: component.errors.full_messages.first) if component.errors.any?
        end
      end

      desc 'Delete component'
      params do
        requires :id, type: Integer, desc: 'Ingredient id'
      end
      delete ':id' do
        return { error: 'not authorized' } if !user_admin? @current_user
        component = Ingredient.find(params[:id])
        {status: :success} if component.delete
      end
      # end
    end
  end
end