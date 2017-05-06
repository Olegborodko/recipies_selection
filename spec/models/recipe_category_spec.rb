require 'spec_helper'
require 'rails_helper'
require 'support/factory_girl'

RSpec.describe RecipeCategory, type: :model do

  it 'is valid with valid attributes' do
    expect(build(:recipe_category)).to be_valid
  end

  describe 'validation' do

    it 'is not valid without a title' do
      expect(build(:recipe_category, title: nil)).to_not be_valid
    end

    it 'is not valid without a to shot title' do
      expect(build(:recipe_category, title: 'a')).to_not be_valid
    end

    it 'is invalid with a duplicated title' do
      create(:recipe_category, title: 'qqq')
      expect(build(:recipe_category, title: 'qqq')).to_not be_valid
    end
  end
end