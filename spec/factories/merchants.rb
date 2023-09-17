FactoryBot.define do
  factory :merchant do
    name { Faker::Name.name }
    disabled { false }
    created_at { "2023-09-11 16:41:38" }
    updated_at { "2023-09-11 16:41:38" }
  end
end
