class InvoiceItem < ApplicationRecord
  belongs_to :item
  has_one :merchant, through: :item
  belongs_to :invoice

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :status, presence: true

  enum :status, ["pending", "packaged", "shipped"]

  def self.merchant_specific(merchant)
    where(item: merchant.items)
  end

  def discounted_revenue
    base_price = unit_price
    bulk_discounts = merchant.bulk_discounts.where("threshold <= ?", quantity).order(percentage_discount: :desc)

    if bulk_discounts.any?
      discount = bulk_discounts.first.percentage_discount
      discounted_price = base_price * (1 - discount)
    else
      discounted_price = base_price
    end

    quantity * discounted_price
  end
end
