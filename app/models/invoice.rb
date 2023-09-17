class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items

  validates :status, presence: true

  enum :status,["in progress", "completed", "cancelled"]

  def self.not_fulfilled
    where(status: 0)
  end
end
