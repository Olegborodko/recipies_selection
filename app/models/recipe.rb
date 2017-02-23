class Recipe < ApplicationRecord
  belongs_to :recipe_category
  has_many :ingredients

  has_many :favoriterecipes
  has_many :users, :through => :favoriterecipes
end
