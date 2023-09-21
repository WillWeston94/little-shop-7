FactoryBot.define do
  factory :bulk_discount do
    association :merchant
    percentage_discount { Faker::Number.between(from: 1, to: 75) }
    threshold { Faker::Number.between(from: 1, to: 50) }
  end
end
