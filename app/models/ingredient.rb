class Ingredient < ApplicationRecord
  belongs_to :ingredient_category, inverse_of: :ingredients
  has_many :recipe_ingredients, inverse_of: :ingredient
  has_many :recipes, through: :recipe_ingredients

  validates :name,
            presence: { message: 'Name must be given please' },
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 100 },
            on: [:create, :update],
            if: :sum?
  validates :content,
            length: { maximum: 10_000 }

  validates :protein, :carbohydrate, :fat, :calories, presence: true

  def sum?
    (carbohydrate.to_i + fat.to_i + protein.to_i).to_i <= 100
  end
end
