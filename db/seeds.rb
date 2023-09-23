require 'faker'

100.times do
  BulkDiscount.create(
    percentage_discount: (1..75).to_a.sample / 100.0,
    threshold: Faker::Number.between(from: 5, to: 50),
    merchant_id: Merchant.pluck(:id).sample
  )
end