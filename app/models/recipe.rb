class Recipe < ApplicationRecord
  belongs_to :recipe_category

  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  has_many :favorite_recipes
  has_many :users, :through => :favorite_recipes

  # define_index do
  #   indexes :name
  #   indexes :content
  #   indexes :ingredients.name, as: :ingredient_name
  #   indexes :ingredients.content, as: :ingredient_content
  #   indexes :recipe_category.title, as: :recipe_category
  #
  # end
end
