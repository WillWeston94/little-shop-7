class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  validates :percentage_discount, presence: true
  validates :threshold, presence: true

end
