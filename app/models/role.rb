class Role < ApplicationRecord
  has_many :users

  validates :title, presence: true, length: { minimum: 2, maximum: 100 }
end
