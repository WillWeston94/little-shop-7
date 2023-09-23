class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :percentage_discount, presence: true, numericality: { less_than_or_equal_to: 0.99, greater_than_or_equal_to: 0.01  }
  validates :threshold, presence: true

end
