FactoryBot.define do
  factory :holiday_discount do
    name { "MyString" }
    percentage_discount { "9.99" }
    threshold { 1 }
    holiday_date { "2023-09-26" }
    merchant { nil }
  end
end
