class Recipe < ApplicationRecord
  include PgSearch

  belongs_to :recipe_category, inverse_of: :recipes
  has_many :recipe_ingredients, inverse_of: :recipe, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :users, through: :favorite_recipes
  has_many :favorite_recipes , dependent: :destroy, inverse_of: :recipe

  validates :name,
            uniqueness: { case_sensitive: false },
            length: { minimum: 2, maximum: 100 },
            on: [:create, :update],
            presence: { message: 'Name must be given please' },
            if: :sum?
  validates :content,
            uniqueness: { case_sensitive: false },
            length: { minimum: 50, maximum: 10_000 },
            on: [:create, :update],
            presence: { message: 'Content must be given please' }
  validates_associated :recipe_ingredients, :favorite_recipes, :ingredients

  def sum?
    (carbohydrate + fat + protein).to_i <= 100
  end

  pg_search_scope :search,
                  against: [:name],
                  using: { tsearch: { dictionary: 'russian',
                                      prefix: true,
                                      any_word: true } },
                  associated_against: { ingredients: [:name] },
                  ignoring: :accents

  def self.text_search(query)
    if query.present?
      # search(query)
      rank = <<-RANK
        ts_rank(to_tsvector(name), plainto_tsquery(#{sanitize(query)})) +
        ts_rank(to_tsvector(content), plainto_tsquery(#{sanitize(query)}))
      RANK
      where("to_tsvector('russian', name) @@ :q or to_tsvector('russian', content) @@ :q", q: query).order("#{rank}Desc")
    else
      scoped
    end
  end

  def ingredient_numbers
    recipe_ingredients.each_with_object({}) do |ri, obj|
      obj[ri.ingredient.name] = ri.number_of_ingredient
    end
  end

  def self.update_index
    Recipe.find_each(&:touch)
  end
end

