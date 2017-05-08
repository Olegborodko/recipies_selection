module Entities
  class Receipt < Entities::RecipeBase
    root 'receipts', 'receipt'

    format_with(:iso_timestamp) { |dt| dt.to_i }

    expose :ingredient_numbers

    with_options(format_with: :iso_timestamp) do
      expose :created_at
      expose :updated_at
    end
  end
end