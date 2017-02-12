class IngredientCategory < ApplicationRecord
  has_many :ingredients, dependent: :destroy
end
