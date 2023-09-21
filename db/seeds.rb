# require 'faker'

# 100.times do
#   BulkDiscount.create(
#     percentage_discount: Faker::Number.decimal(l_digits: 2),
#     threshold: Faker::Number.between(from: 5, to: 50),
#     merchant_id: Merchant.pluck(:id).sample
#   )
# end