class Recipe < ApplicationRecord
  belongs_to :recipe_category

  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients

  has_many :favorite_recipes
  # has_many (or has_and_belongs_to_many):users, :through => :favorite_recipes    <- need create join table recipes_users

  include PgSearch
  pg_search_scope :search, against: [:name, :content],
                  using: {tsearch: {dictionary: "english"}},
                  associated_against: {recipe_category: :title, ingredients: [:name, :content],
                                       # users: [:name, :email, :slug]
                  },
                  ignoring: :accents


  def self.text_search(query)
    if query.present?
      # search(query)
      rank = <<-RANK
        ts_rank(to_tsvector(name), plainto_tsquery(#{sanitize(query)})) + 
        ts_rank(to_tsvector(content), plainto_tsquery(#{sanitize(query)}))
      RANK
      where("to_tsvector('english', name) @@ :q or to_tsvector('english', content) @@ :q", q: query).order("#{rank} desk")
    else
      scoped
    end
  end
end
