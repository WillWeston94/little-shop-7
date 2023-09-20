require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it { should have_many :invoices }
  end

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
  end

  describe "#order_customers_by_transactions" do
    it "can order the customers by amount of transactions" do
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)
      customer_4 = create(:customer)
      customer_5 = create(:customer)
      customer_6 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1)
      invoice_2 = create(:invoice, customer: customer_2)
      invoice_3 = create(:invoice, customer: customer_3)
      invoice_4 = create(:invoice, customer: customer_4)
      invoice_5 = create(:invoice, customer: customer_5)
      invoice_6 = create(:invoice, customer: customer_6)

      transactions_for_invoice_1 = create_list(:transaction, 4, invoice: invoice_1)
      transactions_for_invoice_2 = create_list(:transaction, 5, invoice: invoice_2)
      transactions_for_invoice_3 = create_list(:transaction, 6, invoice: invoice_3)
      transactions_for_invoice_4 = create_list(:transaction, 1, invoice: invoice_4)
      transactions_for_invoice_5 = create_list(:transaction, 2, invoice: invoice_5)
      transactions_for_invoice_6 = create_list(:transaction, 3, invoice: invoice_6)

      @customers = Customer.all

      expect(@customers.order_customers_by_transactions).to eq([customer_3, customer_2, customer_1, customer_6, customer_5])
    end
  end

  describe "#amount of transactions" do
    it "can count the amount of transactions from a customer" do
      customer_1 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1)

      transactions_for_invoice_1 = create_list(:transaction, 4, invoice: invoice_1)

      expect(customer_1.amount_of_transactions).to eq(4)
    end
  end
end
