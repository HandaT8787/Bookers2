FactoryBot.define do
  factory :group do
    name { Faker::Lorem.characters(number: 10) }
    association :owner, factory: :user
  end
end
