class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices

  validates :name, presence: true

  before_validation :default_status

  def toggle_disabled
    update(disabled: !disabled)
  end

  def default_status
    self.disabled = true if self.disabled.nil?
  end

  def self.top_revenue
    joins(invoices: :transactions)
      .where(transactions: { result: 1 })
      .group('merchants.id')
      .order(Arel.sql('SUM(invoice_items.quantity * invoice_items.unit_price) DESC'))
      .limit(5)
  end

  def revenue
    invoices
      .joins(:transactions)
      .where(transactions: { result: 1 })
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def top_date
    invoices
      .joins(:invoice_items)
      .group('DATE(invoices.created_at)')
      .select('DATE(invoices.created_at) AS date, SUM(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
      .order(Arel.sql('SUM(invoice_items.quantity * invoice_items.unit_price) DESC'))
      .limit(1)
      .pluck('DATE(invoices.created_at)')
      .first
  end

  def ready_to_ship 
    items
      .joins(:invoice_items)
      .joins("INNER JOIN invoices ON invoices.id = invoice_items.invoice_id")
      .where(invoice_items: {status: 1})
      .order("invoices.created_at ASC")
  end

  def most_popular_items
    items
      .joins(:invoice_items)
      .select("items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS item_revenue")
      .where("invoice_items.status = ?", 1)
      .group("items.id")
      .order("item_revenue DESC")
      .limit(5)
  end
end
