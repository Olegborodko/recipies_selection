class Recipe < ApplicationRecord
  belongs_to :recipe_category

  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  has_many :favorite_recipes
  has_many :users, :through => :favorite_recipes

  include PgSearch
  # pg_search_scope :search_everywhere, against: [:name, :content]
  multisearchable against: [:name, :content]

  after_save :reindex

  private

  def reindex
    PgSearch::Multisearch.rebuild(Recipe)
  end

end
