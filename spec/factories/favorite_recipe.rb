FactoryGirl.define do
  factory :favorite_recipe do
    association :user, factory: :user
    association :recipe, factory: :recipe
  end
end