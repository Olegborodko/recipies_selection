module Entities
  class Receipt < Grape::Entity
    root 'receipts', 'receipt'

    format_with(:iso_timestamp) { |dt| dt.to_i }

    expose :id
    expose :name
    expose :content
    expose :cooking_time
    expose :calories
    expose :protein
    expose :fat
    expose :carbohydrate
    expose :ingredients, using: Api::Entities::Ingredient

    data = Entity.represent(model)
    data.as_json
    # expose :ingredients do |instance, options|
    #   instance.ingredients.recipe_ingredients.number_of_ingredient
    # end
    # # expose :number_of_ingredient

    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end