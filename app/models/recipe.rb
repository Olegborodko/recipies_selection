class Recipe < ApplicationRecord
  include PgSearch

  belongs_to :recipe_category

  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  has_many :favorite_recipes
  has_many :users, :through => :favorite_recipes

  pg_search_scope :search, :against => [:name, :content],
                  :associated_against => { ingredients: [:name, :content] },
                  :using => [:tsearch, :trigram, :dmetaphone, :tsearch => {:any_word => true}]
end
