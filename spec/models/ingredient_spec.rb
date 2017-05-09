require 'spec_helper'
require 'rails_helper'
require 'support/factory_girl'

c = Faker::Lorem.sentences(3)

RSpec.describe Ingredient, type: :model do

  it 'is valid with valid attributes' do
    expect(build(:ingredient)).to be_valid
  end

  describe 'validation' do

    it 'is not valid without a name' do
      expect(build(:ingredient, name: nil)).to_not be_valid
    end

    it 'is not valid without a protein' do
      expect(build(:ingredient, protein: nil)).to_not be_valid
    end

    it 'is not valid without a calories' do
      expect(build(:ingredient, calories: nil)).to_not be_valid
    end

    it 'is not valid without a carbohydrate' do
      expect(build(:ingredient, carbohydrate: nil)).to_not be_valid
    end

    it 'is not valid without a fat' do
      expect(build(:ingredient, fat: nil)).to_not be_valid
    end


    it 'is not valid with a too shot name' do
      expect(build(:ingredient, name: 'a')).to_not be_valid
    end

    it 'is invalid with a duplicated name' do
      create(:ingredient, name: 'qqq')
      expect(build(:ingredient, name: 'qqq')).to_not be_valid
    end

    it 'is invalid with a duplicated content' do
      create(:ingredient, content: c)
      expect(build(:ingredient, content: c)).to_not be_valid
    end
  end
end