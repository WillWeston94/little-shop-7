require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
  end

  describe "validations" do
    it { should validate_presence_of(:status) }
  end

  describe "#not_fulfilled" do
    it "can return all invoices that are not fulfilled" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, status: 0)
      invoice_2 = create(:invoice, customer: customer_1, status: 1)

      @invoices = Invoice.all

      expect(@invoices.not_fulfilled).to eq([invoice_1])
    end

    it "organizes the invoices from oldes to newest" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, status: 0, created_at: DateTime.now)
      invoice_2 = create(:invoice, customer: customer_1, status: 0)

      @invoices = Invoice.all

      expect(@invoices.not_fulfilled).to eq([invoice_2, invoice_1])
    end
  end

  describe "#total_revenue" do
    it "can return the total revenue for an invoice" do
      customer_1 = create(:customer)
      merchant_1 = create(:merchant)

      item_1 = create(:item, merchant: merchant_1, unit_price: 1000)
      item_2 = create(:item, merchant: merchant_1, unit_price: 2000)

      invoice_1 = create(:invoice, customer: customer_1)
      invoice_2 = create(:invoice, customer: customer_1)

      invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 1, unit_price: 1000)
      invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 2, unit_price: 2000)

      transaction_1 = create(:transaction, invoice: invoice_1)
      transaction_2 = create(:transaction, invoice: invoice_2)

      invoices = Invoice.all

      total_revenue = invoices.sum(&:total_revenue)

      expect(total_revenue).to eq(5000)
    end
  end
end
