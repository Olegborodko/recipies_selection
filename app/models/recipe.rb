class Recipe < ApplicationRecord
  belongs_to :recipe_category
  has_many :ingredients
end
