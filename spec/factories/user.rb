FactoryGirl.define do
  factory :user do
    email { Faker::Internet.unique.email }
    status { 'subscriber' }
    password { password_generate }
    name { Faker::Name.name }
  end
end