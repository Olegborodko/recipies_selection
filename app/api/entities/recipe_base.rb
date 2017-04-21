module Entities
  class RecipeBase < Grape::Entity
    expose :id
    expose :name
    expose :content
    expose :cooking_time
    expose :calories
    expose :protein
    expose :fat
    expose :carbohydrate
  end
end