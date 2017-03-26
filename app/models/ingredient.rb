class Ingredient < ApplicationRecord
  belongs_to :ingredient_category
  has_many :recipe_ingredients
  has_many :recipes, through: :recipe_ingredients

  include PgSearch
  multisearchable against: [:name, :content]

  after_save :reindex

  private

  def reindex
    PgSearch::Multisearch.rebuild(Ingredient)
  end
end
