FactoryGirl.define do
  factory :ingredient, class: Ingredient do
    association :ingredient_category, factory: :ingredient_category
    name { Faker::Name.name }
    content { Faker::Lorem.sentences(3); }
    protein { Faker::Number.number(1).to_s }
    calories { Faker::Number.number(4).to_s }
    carbohydrate { Faker::Number.number(1).to_s }
    fat { Faker::Number.number(1).to_s }
  end
end