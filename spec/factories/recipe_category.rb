FactoryGirl.define do
  factory :recipe_category do
    title { Faker::Name.name }
  end
end