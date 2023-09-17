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
      invoice_2 = create(:invoice, customer: customer_1)
      invoice_3 = create(:invoice, customer: customer_1, status: 0)

      @invoices= Invoice.all

      expect(@invoices.not_fulfilled).to eq([invoice_1, invoice_3])
    end
  end
end