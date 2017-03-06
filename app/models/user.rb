class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  belongs_to :role
  has_many :favorite_recipes
  has_many :recipes, :through => :favorite_recipes

  has_secure_password
  has_secure_token :rid

  validates_email_format_of :email, message: 'is not looking good'
  validates :email, uniqueness: { case_sensitive: false, message: 'already exists'}
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: {maximum: 1000 }
  validates :password, presence: true, confirmation: true, length: { minimum: 6 }

  before_create do
    self.email = email.downcase
  end
end
