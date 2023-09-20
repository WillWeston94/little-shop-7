FactoryBot.define do
  factory :invoice do
    association :customer
    status { [0, 1, 2].sample }
    created_at { Faker::Time.backward(days: 30) }
    updated_at { DateTime.now }
  end
end
