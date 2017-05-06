FactoryGirl.define do
  factory :recipe, class: Recipe do
    association :recipe_category, factory: :recipe_category
    name { Faker::Name.name }
    content { Faker::Lorem.words(55); }
    cooking_time { Faker::Lorem.sentence(2).to_s }
    protein { Faker::Number.number(1).to_s }
    calories { Faker::Number.positive(1, 10_000).to_s }
    carbohydrate { Faker::Number.number(1).to_s }
    fat { Faker::Number.number(1).to_s }
  end
end