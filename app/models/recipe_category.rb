class RecipeCategory < ApplicationRecord
  has_many :recipes, dependent: :destroy

  validates :title,
            presence: { message: "Name must be given please" },
            uniqueness: { case_sensitive: false },
            on: [:create, :update],
            length: { minimum: 2, maximum: 100 }
end
