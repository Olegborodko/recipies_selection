module Modules
  class Components < Grape::API
    prefix :api
    format :json

    desc 'Ingredients controller'
    namespace 'categories_of_ingredients/:ingredient_category_id' do
      resource :components do

        helpers do
          def set_category
            IngredientCategory.find(params[:ingredient_category_id])
          end
        end

        desc 'All ingredients in current category'
        get do
          components = set_category.ingredients
          present components, with: Api::Entities::Component
        end

        desc 'Current ingredient in current category'
        get ':id' do
          {category_of_ingredients_id: params[:id]}
        end

        params do
          requires :component, type: Hash do
            requires :name, type: String
            requires :content, type: String
            requires :href, type: String
            requires :calories, type: Float
            requires :protein, type: Float
            requires :fat, type: Float
            requires :carbohydrate, type: Float
          end
        end

        desc 'Create new ingredient'
        post do
          component = set_category.ingredients.create(
              declared(params, include_missing: false)[:component])
          component.save
          present component, with: Api::Entities::Component
        end

        desc 'Update ingredient'
        put ':id' do
          component = set_category.ingredients.find(params[:id])
          component.update({
              name: params[:name],
              content: params[:content],
              href: params[:href],
              calories: params[:calories],
              protein: params[:protein],
              fat: params[:fat],
              carbohydrate: params[:carbohydrate]})
        end

        desc 'Delete ingredient'
        delete ':id' do
          set_category.ingredients.find(params[:id]).destroy
        end

      end
    end
  end
end