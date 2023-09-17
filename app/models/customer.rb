class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.order_customers_by_transactions
    joins(:transactions)
      .where(transactions: { result: 1 })
      .group('customers.id, customers.first_name, customers.last_name')
      .order('COUNT(transactions.id) DESC')
      .limit(5)
  end

  def amount_of_transactions
    invoices.joins(:transactions)
      .where(transactions: { result: 1 })
      .count
  end
end