class User < ApplicationRecord
  has_secure_password
  has_secure_token :rid

  belongs_to :role
  has_many :favoriterecipes
  has_many :recipes, :through => :favoriterecipes

  validates_email_format_of :email, :message => 'is not looking good'
  #validates :password_digest, presence: true, length: { minimum: 6, maximum: 100 }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :description, length: {maximum: 1000 }
end
