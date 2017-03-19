# module Modules
  module Entities
    class CategoryOfIngredients < Grape::Entity
      root 'categories_of_ingredients', 'category_of_ingredients'

      format_with(:iso_timestamp) { |dt| dt.to_i }

      expose :id
      expose :title

      with_options(format_with: :iso_timestamp) do
        expose :created_at
        expose :updated_at
      end
    end
  end
# end