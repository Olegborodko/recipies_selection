class User < ApplicationRecord
  has_secure_password
  has_secure_token :rid

  belongs_to :role
  has_many :favorite_recipes
  has_many :recipes, :through => :favorite_recipes

  validates_email_format_of :email, :message => 'is not looking good'
  validates :email, uniqueness: { case_sensitive: false, :message => 'already exists'}
  #validates :password_digest, presence: true, length: { minimum: 6, maximum: 100 }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: {maximum: 1000 }
end
