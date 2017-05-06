require 'spec_helper'
require 'rails_helper'
require 'support/factory_girl'

RSpec.describe IngredientCategory, type: :model do

  it 'is valid with valid attributes' do
    expect(build(:ingredient_category)).to be_valid
  end

  describe 'validation' do

    it 'is not valid without a title' do
      expect(build(:ingredient_category, title: nil)).to_not be_valid
    end

    it 'is not valid with a too shot title' do
      expect(build(:ingredient_category, title: 'a')).to_not be_valid
    end

    it 'is invalid with a duplicated title' do
      create(:ingredient_category, title: 'qqq')
      expect(build(:ingredient_category, title: 'qqq')).to_not be_valid
    end
  end
end