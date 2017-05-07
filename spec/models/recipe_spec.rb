require 'spec_helper'
require 'rails_helper'
require 'support/factory_girl'

c = Faker::Lorem.sentences(3)

RSpec.describe Recipe, type: :model do

  it 'is valid with valid attributes' do
    expect(build(:recipe)).to be_valid
  end

  describe 'validation' do

    it 'is not valid without a name' do
      expect(build(:recipe, name: nil)).to_not be_valid
    end

    it 'is not valid without a content' do
      expect(build(:recipe, content: nil)).to_not be_valid
    end

    it 'is not valid without a protein' do
      expect(build(:recipe, protein: nil)).to_not be_valid
    end

    it 'is not valid without a calories' do
      expect(build(:recipe, calories: nil)).to_not be_valid
    end

    it 'is not valid without a carbohydrate' do
      expect(build(:recipe, carbohydrate: nil)).to_not be_valid
    end

    it 'is not valid without a fat' do
      expect(build(:recipe, fat: nil)).to_not be_valid
    end


    it 'is not valid with a too shot name' do
      expect(build(:recipe, name: 'a')).to_not be_valid
    end

    it 'is not valid with a too shot content' do
      expect(build(:recipe, content: 'a')).to_not be_valid
    end

    it 'is invalid with a duplicated name' do
      create(:recipe, name: 'qqq')
      expect(build(:recipe, name: 'qqq')).to_not be_valid
    end

    it 'is invalid with a duplicated content' do
      create(:recipe, content: c)
      expect(build(:recipe, content: c)).to_not be_valid
    end
  end
end