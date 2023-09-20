class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  validates :quantity, presence: true
  validates :unit_price, presence: true


  enum :status, ["pending", "packaged", "shipped"]

  def self.merchant_specific(merchant)
    where(item: merchant.items)
  end
end
