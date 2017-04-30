class Ingredient < ApplicationRecord
  belongs_to :ingredient_category, inverse_of: :ingredients
  has_many :recipe_ingredients, inverse_of: :ingredient
  has_many :recipes, through: :recipe_ingredients, inverse_of: :ingredient

  validates :name,
            presence: { message: "Name must be given please" },
            uniqueness: { case_sensitive: false },
            on: [:create, :update],
            if: :sum?
  validates :content,
            presence: { message: "Content must be given please" }

  def sum?
    (carbohydrate + fat + protein).to_i <= 100
  end
end
