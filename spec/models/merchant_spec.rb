require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "instance methods" do
    describe "default status" do
      it "merchant loads with default status disabled" do
        merchant = Merchant.create(name: "whatever")

        expect(merchant.disabled).to eq(true)
      end
    end

    describe "Top date" do
      it "returns the date with the most sales for a merchant" do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_3 = create(:merchant)
  
        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)
  
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_2)
        item_3 = create(:item, merchant: merchant_3)
  
        invoice_1 = create(:invoice, customer: customer_1, created_at: "2021-04-01 14:54:05 UTC")
        invoice_2 = create(:invoice, customer: customer_2, created_at: "2021-04-06 11:33:00 UTC")
        invoice_3 = create(:invoice, customer: customer_3, created_at: "2021-04-10 20:00:22 UTC")
  
        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 1, unit_price: 1000)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 1, unit_price: 2000)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 1, unit_price: 3000)
  
        transaction_1 = create(:transaction, invoice: invoice_1, result: 1)
        transaction_2 = create(:transaction, invoice: invoice_2, result: 1)
        transaction_3 = create(:transaction, invoice: invoice_3, result: 1)
  
        expect(merchant_1.top_date).to eq(Date.new(2021, 4, 1))
        expect(merchant_2.top_date).to eq(Date.new(2021, 4, 6))
        expect(merchant_3.top_date).to eq(Date.new(2021, 4, 10))
      end
    end

    describe "#most_popular_items" do
      it "returns the top 5 items by revenue for a merchant" do
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)

        customer_1 = create(:customer)
        customer_2 = create(:customer)

        invoice_1 = create(:invoice, customer: customer_1)
        invoice_2 = create(:invoice, customer: customer_1)
        invoice_3 = create(:invoice, customer: customer_2)
        invoice_4 = create(:invoice, customer: customer_2)

        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_1) #
        item_3 = create(:item, merchant: merchant_1) #
        item_4 = create(:item, merchant: merchant_1)
        item_5 = create(:item, merchant: merchant_1) #
        item_6 = create(:item, merchant: merchant_1) #
        item_7 = create(:item, merchant: merchant_1) #
        item_8 = create(:item, merchant: merchant_2)
        item_9 = create(:item, merchant: merchant_2)

        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 1, unit_price: 500, status: 1)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_1, quantity: 1, unit_price: 1000, status: 1)
        invoice_item_3 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 3, unit_price: 1000, status: 1)
        invoice_item_4 = create(:invoice_item, item: item_3, invoice: invoice_2, quantity: 2, unit_price: 1500, status: 1)
        invoice_item_5 = create(:invoice_item, item: item_4, invoice: invoice_2, quantity: 10, unit_price: 40, status: 1)
        invoice_item_6 = create(:invoice_item, item: item_5, invoice: invoice_1, quantity: 1, unit_price: 1000, status: 1)
        invoice_item_7 = create(:invoice_item, item: item_6, invoice: invoice_1, quantity: 7, unit_price: 500, status: 1)
        invoice_item_8 = create(:invoice_item, item: item_7, invoice: invoice_1, quantity: 4, unit_price: 1200, status: 1)
        # item2 = 4000, item3 = 3000, item5 = 1000, item6 = 3500, item7 = 4800 || item1 = 500, item4 = 400
        invoice_item_9 = create(:invoice_item, item: item_8, invoice: invoice_3, quantity: 10, unit_price: 1200, status: 1)
        invoice_item_10 = create(:invoice_item, item: item_9, invoice: invoice_4, quantity: 7, unit_price: 1000, status: 1)
        expect(merchant_1.most_popular_items).to eq([item_7, item_2, item_6, item_3, item_5])
      end
    end
  end

  describe "class methods" do
    describe "top_revenue" do
      it "returns the top 5 merchants by revenue" do  
        merchant_1 = create(:merchant)
        merchant_2 = create(:merchant)
        merchant_3 = create(:merchant)
        merchant_4 = create(:merchant)
        merchant_5 = create(:merchant)
        merchant_6 = create(:merchant)
        merchant_7 = create(:merchant)
        merchant_8 = create(:merchant)
        merchant_9 = create(:merchant)
        merchant_10 = create(:merchant)
  
        customer_1 = create(:customer)
        customer_2 = create(:customer)
        customer_3 = create(:customer)
        customer_4 = create(:customer)
        customer_5 = create(:customer)
        customer_6 = create(:customer)
        customer_7 = create(:customer)
        customer_8 = create(:customer)
        customer_9 = create(:customer)
        customer_10 = create(:customer)
  
        item_1 = create(:item, merchant: merchant_1)
        item_2 = create(:item, merchant: merchant_2)
        item_3 = create(:item, merchant: merchant_3)
        item_4 = create(:item, merchant: merchant_4)
        item_5 = create(:item, merchant: merchant_5)
        item_6 = create(:item, merchant: merchant_6)
        item_7 = create(:item, merchant: merchant_7)
        item_8 = create(:item, merchant: merchant_8)
        item_9 = create(:item, merchant: merchant_9)
        item_10 = create(:item, merchant: merchant_10)
  
        invoice_1 = create(:invoice, customer: customer_1)
        invoice_2 = create(:invoice, customer: customer_2)
        invoice_3 = create(:invoice, customer: customer_3)
        invoice_4 = create(:invoice, customer: customer_4)
        invoice_5 = create(:invoice, customer: customer_5)
        invoice_6 = create(:invoice, customer: customer_6)
        invoice_7 = create(:invoice, customer: customer_7)
        invoice_8 = create(:invoice, customer: customer_8)
        invoice_9 = create(:invoice, customer: customer_9)
        invoice_10 = create(:invoice, customer: customer_10)
  
        invoice_item_1 = create(:invoice_item, item: item_1, invoice: invoice_1, quantity: 1, unit_price: 1000)
        invoice_item_2 = create(:invoice_item, item: item_2, invoice: invoice_2, quantity: 1, unit_price: 2000)
        invoice_item_3 = create(:invoice_item, item: item_3, invoice: invoice_3, quantity: 1, unit_price: 3000)
        invoice_item_4 = create(:invoice_item, item: item_4, invoice: invoice_4, quantity: 1, unit_price: 4000)
        invoice_item_5 = create(:invoice_item, item: item_5, invoice: invoice_5, quantity: 1, unit_price: 5000)
        invoice_item_6 = create(:invoice_item, item: item_6, invoice: invoice_6, quantity: 1, unit_price: 6000)
        invoice_item_7 = create(:invoice_item, item: item_7, invoice: invoice_7, quantity: 1, unit_price: 7000)
        invoice_item_8 = create(:invoice_item, item: item_8, invoice: invoice_8, quantity: 1, unit_price: 8000)
        invoice_item_9 = create(:invoice_item, item: item_9, invoice: invoice_9, quantity: 1, unit_price: 9000)
        invoice_item_10 = create(:invoice_item, item: item_10, invoice: invoice_10, quantity: 1, unit_price: 10000)
  
        transaction_1 = create(:transaction, invoice: invoice_1, result: 1)
        transaction_2 = create(:transaction, invoice: invoice_2, result: 1)
        transaction_3 = create(:transaction, invoice: invoice_3, result: 1)
        transaction_4 = create(:transaction, invoice: invoice_4, result: 1)
        transaction_5 = create(:transaction, invoice: invoice_5, result: 1)
        transaction_6 = create(:transaction, invoice: invoice_6, result: 1)
        transaction_7 = create(:transaction, invoice: invoice_7, result: 1)
        transaction_8 = create(:transaction, invoice: invoice_8, result: 1)
        transaction_9 = create(:transaction, invoice: invoice_9, result: 1)
        transaction_10 = create(:transaction, invoice: invoice_10, result: 1)
  
        expect(Merchant.top_revenue).to eq([merchant_10, merchant_9, merchant_8, merchant_7, merchant_6])
      end
    end
  end

  describe "ready_to_ship" do
    it "finds all the invoice items with the status" do
      merchant_1 = create(:merchant)
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)
      customer_4 = create(:customer)
      customer_5 = create(:customer)
      
      item_1 = create(:item, merchant_id: merchant_1.id)
      item_2 = create(:item, merchant_id: merchant_1.id)
      item_3 = create(:item, merchant_id: merchant_1.id)
      item_4 = create(:item, merchant_id: merchant_1.id)
      item_5 = create(:item, merchant_id: merchant_1.id)

      invoice_1 = create(:invoice, customer_id: customer_1.id, created_at: "2012-03-25 09:54:09 UTC")
      invoice_2 = create(:invoice, customer_id: customer_2.id, created_at: "2012-03-26 09:54:09 UTC")
      invoice_3 = create(:invoice, customer_id: customer_3.id, created_at: "2012-03-27 09:54:09 UTC")
      invoice_4 = create(:invoice, customer_id: customer_4.id, created_at: "2012-03-28 09:54:09 UTC")
      invoice_5 = create(:invoice, customer_id: customer_5.id)

      invoice_item_1 = create(:invoice_item, item_id: item_1.id, invoice_id: invoice_1.id, status: 1)
      invoice_item_2 = create(:invoice_item, item_id: item_2.id, invoice_id: invoice_2.id, status: 1)
      invoice_item_3 = create(:invoice_item, item_id: item_3.id, invoice_id: invoice_3.id, status: 0)
      invoice_item_4 = create(:invoice_item, item_id: item_4.id, invoice_id: invoice_4.id, status: 1)
      invoice_item_5 = create(:invoice_item, item_id: item_5.id, invoice_id: invoice_5.id, status: 1)

      transaction_1 = create(:transaction, invoice_id: invoice_1.id, result: 1)
      transaction_2 = create(:transaction, invoice_id: invoice_2.id, result: 1)
      transaction_3 = create(:transaction, invoice_id: invoice_3.id, result: 1)
      transaction_4 = create(:transaction, invoice_id: invoice_4.id, result: 1)
      transaction_5 = create(:transaction, invoice_id: invoice_5.id, result: 1)

      expect(merchant_1.ready_to_ship).to match_array([item_1, item_2, item_4, item_5])
      expect(merchant_1.ready_to_ship).to_not include([item_3])
    end
  end
end

