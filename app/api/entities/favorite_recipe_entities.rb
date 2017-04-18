module Entities
  class FavoriteRecipeEntities < Grape::Entity
    #include Grape::Entity::DSL
    #present_collection true
    expose :category do |i, o|
      i.recipe.recipe_category.title
    end
    expose :recipe, using: Entities::RecipeBase

    expose :note
  end
end