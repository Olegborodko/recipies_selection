class Recipe < ApplicationRecord
  include PgSearch

  belongs_to :recipe_category
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :favorite_recipes
  has_many :users, through: :recipe_ingredients
  # has_many (or has_and_belongs_to_many):users, :through => :favorite_recipes    <- need create join table recipes_users

  pg_search_scope :search,
                  against: [:name],
                  using: { tsearch: { dictionary: "russian",
                                      prefix: true,
                                      any_word: true } },
                  associated_against: { ingredients: [:name] },
                  ignoring: :accents

  def self.text_search(query)
    if query.present?
      # search(query)
      rank = <<-RANK
        ts_rank(to_tsvector(name), plainto_tsquery(#{sanitize(query)}))
      RANK
      where("to_tsvector('russian', name) @@ :q or to_tsvector('russian', content) @@ :q", q: query).order("#{rank}Desc")
    else
      scoped
    end
  end

  def ingredient_numbers
    ri_all = Recipe.find(self.id).recipe_ingredients
    ri_all.each_with_object({}) do |ri, obj|
      obj[ri.ingredient.name] = ri.number_of_ingredient
    end
  end

  def self.update_index
    Recipe.find_each(&:touch)
  end
end

