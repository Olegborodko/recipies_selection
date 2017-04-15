class Ingredient < ApplicationRecord
  belongs_to :ingredient_category
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients
  
end
