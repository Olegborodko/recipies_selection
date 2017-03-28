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
          set_category.recipes.find(params[:id])
        end

        desc 'Create new receipt'
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
        post do
          begin
            receipt = set_category.recipes.create({
                                                      name: params[:name],
                                                      content: params[:content],
                                                      cooking_time: params[:cooking_time],
                                                      ccal: params[:ccal]
                                                  })
            if receipt.save
              {status: :success}
            else
              error!({status: :error, message: receipt.errors.full_messages.first}) if receipt.errors.any?
            end
          rescue ActiveRecord::RecordNotFound
            error!({status: :error, message: :not_found}, 404)
          end
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
          begin
            receipt = set_category.recipes.find(params[:id])
            if receipt.update({
                                  name: params[:name],
                                  content: params[:content],
                                  cooking_time: params[:cooking_time],
                                  ccal: params[:ccal]
                              })
              {status: :success}
            else
              error!({status: :error, message: receipt.errors.full_messages.first}) if receipt.errors.any?
            end


          rescue ActiveRecord::RecordNotFound
            error!({status: :error, message: :not_found}, 404)
          end
        end

        desc 'Delete receipt'
        params do
          requires :id, type: Integer, desc: "Product id"
        end

        delete ':id' do
          begin
            receipt = set_category.recipes.find(params[:id])
            {status: :success} if receipt.delete
          rescue ActiveRecord::RecordNotFound
            error!({status: :error, message: :not_found}, 404)
          end
        end
      end
    end
  end
end