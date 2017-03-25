# module Modules
module Entities
  class CategoryOfRecipes < Grape::Entity
    root 'categories_of_recipes', 'category_of_recipes'
    expose :id
    expose :title
  end
end
# end