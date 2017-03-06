class Recipe < ApplicationRecord
  belongs_to :recipe_category

  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  has_many :favorite_recipes
  has_many :users, :through => :favorite_recipes
end
