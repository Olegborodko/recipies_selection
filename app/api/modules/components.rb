module Modules
  class Components < Grape::API
    prefix :api
    format :json

    desc 'Ingredients controller'
    namespace 'categories_of_ingredients/:category_of_ingredients_id' do
      resource :components do

        helpers do
          def set_category
            IngredientCategory.find(params[:category_of_ingredients_id])
          end
        end

        desc 'All ingredients in current category'
        get do
          components = set_category.ingredients
          present components, with: Api::Entities::Component
        end

        desc 'Current ingredient in current category'
        get ':id' do
          set_category.ingredients.find(params[:id])
        end

        desc 'Create new component'
        params do
          requires :component, type: Hash do
            requires :name, type: String
            requires :content, type: String
            requires :href, type: String
            requires :calories, type: Integer
            requires :protein, type: Float
            requires :fat, type: Float
            requires :carbohydrate, type: Float
            # requires :components, type Hash do
            #   requires
            # end

          end
        end
        post do
          begin
            component = set_category.ingredients.create({
                                                            name: params[:name],
                                                            content: params[:content],
                                                            href: params[:href],
                                                            calories: params[:calories],
                                                            protein: params[:protein],
                                                            fat: params[:fat],
                                                            carbohydrate: params[:carbohydrate],
                                                        })
            if component.save
              {status: :success}
            else
              error!({status: :error, message: component.errors.full_messages.first}) if component.errors.any?
            end
          rescue ActiveRecord::RecordNotFound
            error!({status: :error, message: :not_found}, 404)
          end
        end

        desc 'Update component'
        params do
          requires :name, type: String
          requires :content, type: String
          requires :href, type: String
          requires :calories, type: Integer
          requires :protein, type: Float
          requires :fat, type: Float
          requires :carbohydrate, type: Float
        end
        put ':id' do
          begin
            component = set_category.ingredients.find(params[:id])
            if component.update({
                                    name: params[:name],
                                    content: params[:content],
                                    href: params[:href],
                                    calories: params[:calories],
                                    protein: params[:protein],
                                    fat: params[:fat],
                                    carbohydrate: params[:carbohydrate],
                                })
              {status: :success}
            else
              error!({status: :error, message: component.errors.full_messages.first}) if component.errors.any?
            end


          rescue ActiveRecord::RecordNotFound
            error!({status: :error, message: :not_found}, 404)
          end
        end

        desc 'Delete component'
        params do
          requires :id, type: Integer, desc: "Ingredient id"
        end

        delete ':id' do
          begin
            component = set_category.ingredients.find(params[:id])
            {status: :success} if component.delete
          rescue ActiveRecord::RecordNotFound
            error!({status: :error, message: :not_found}, 404)
          end
        end
      end
    end
  end
end