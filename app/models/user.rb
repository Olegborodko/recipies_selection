class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  enum status: [ :unauthorized, :subscriber, :admin, :ban ]

  has_many :favorite_recipes
  has_many :recipes, through: :favorite_recipes

  has_secure_password
  has_secure_token :rid

  validates_email_format_of :email, message: 'is not looking good'
  validates :email, uniqueness: {case_sensitive: false, message: 'already exists'}
  validates :name, presence: true, length: {minimum: 2, maximum: 100}
  validates :description, length: {maximum: 1000}
  validates :password, presence: true, confirmation: true, length: {minimum: 6}

  validate :password_complexity

  def password_complexity
    return if self.password.nil?
    required_complexity = 2 # we're actually storing this in the configuration of each customer
    unless CheckPasswordComplexity.new(password, required_complexity).valid?
      errors.add :password, "Your password does not match the security requirements. Please use A-Z, a-z, 0-9"
    end
  end

  def self.time_for_authentification
    86400 #60 * 60 * 24  = 1day
  end

  before_create do
    self.email = email.downcase
  end
end
