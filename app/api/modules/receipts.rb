module Modules
  class Receipts < Grape::API
    prefix :api
    format :json

    desc 'Receipt controller'
    namespace 'categories_of_recipes/:category_of_recipes_id' do
      resource :recipes do

        helpers do
          def set_category
            RecipeCategory.find(params[:category_of_recipes_id])
          end
        end

        desc 'All recipes in current category'
        get do
          receipt = set_category.recipes
          present receipt, with: Api::Entities::Receipt
        end

        desc 'Current recipe in current category'
        get ':id' do
          {receipt_id: params[:id]}
        end

        params do
          requires :receipt, type: Hash do
            requires :name, type: String
            requires :content, type: String
            requires :cooking_time, type: String
            requires :ccal, type: String
            # requires :components, type Hash do
            #   requires
            # end

          end
        end

        desc 'Create new receipt'
        post do
          receipt = set_category.recipes.create(
              declared(params, include_missing: false)[:receipt])
          receipt.save
          present receipt, with: Api::Entities::Receipt
        end

        desc 'Update receipt'
        params do
          requires :id, type: Integer
          optional :name, type: String
          optional :content, type: String
          optional :cooking_time, type: String
          optional :ccal, type: Float
        end
        put ':id' do
          receipt = set_category.recipes.find(params[:id])
          receipt.update({name: params[:name],
                            content: params[:content],
                            cooking_time: params[:cooking_time],
                            ccal: params[:ccal]})
        end

        desc 'Delete receipt'
        delete ':id' do
          Recipe.find(params[:id]).destroy
        end

      end
    end
  end
end