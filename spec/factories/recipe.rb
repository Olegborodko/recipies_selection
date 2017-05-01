FactoryGirl.define do
  factory :recipe do
    association :recipe_category, factory: :recipe_category
    name { Faker::Name.name }
    content { Faker::Company.catch_phrase }
    cooking_time { Faker::Number.number(2).to_s }
    protein { Faker::Number.number(3).to_s }
    calories { Faker::Number.number(3).to_s }
    carbohydrate { Faker::Number.number(2).to_s }
    fat { Faker::Number.number(2).to_s }
  end
end