FactoryBot.define do
  factory :record do
    weight { 84.2 }
    association :user
  end
end