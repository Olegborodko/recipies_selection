class User < ApplicationRecord
  has_secure_password
  has_secure_token :rid

  belongs_to :role
  has_many :favoriterecipes
  has_many :recipes, :through => :favoriterecipes
end
