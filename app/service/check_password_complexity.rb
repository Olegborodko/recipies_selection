class CheckPasswordComplexity

  attr_reader :password, :required_complexity

  def initialize(password, required_complexity)
    @password = password
    @required_complexity = required_complexity
  end

  def valid?
    score = uppercase_letters_score + digits_score + extra_chars_score + downcase_letters_score

    score >= required_complexity
  end

  private

  def uppercase_letters_score
    password.match(/[A-Z]/) ? 1 : 0
  end

  def digits_score
    password.match(/\d/) ? 1 : 0
  end

  def extra_chars_score
    password.match(/\W/) ? 1 : 0
  end

  def downcase_letters_score
    password.match(/[a-z]/) ? 1 : 0
  end
end