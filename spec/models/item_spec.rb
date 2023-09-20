require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:description) }
  end

  describe "instance methods" do
    describe "unit_price_formatted" do
      it "can convert unit_price to dollars" do
        item = Item.new(unit_price: 12345)
        expect(item.unit_price_formatted).to eq(123.45)
      end
  
      it "can handle zero" do
        item = Item.new(unit_price: 0)
        expect(item.unit_price_formatted).to eq(0)
      end
    end
  
    describe "ready_to_ship" do
      it "can display items with a status of 'packaged'" do
        
      end
    end

    describe "#best_day" do
      before(:each) do
        @merchant_1 = create(:merchant)
    
        @customer_1 = create(:customer)
    
        @invoice_1 = create(:invoice, customer: @customer_1, created_at: "2012-03-25 09:54:09 UTC")
        @invoice_2 = create(:invoice, customer: @customer_1, created_at: "2012-03-26 09:54:09 UTC")
        @invoice_3 = create(:invoice, customer: @customer_1, created_at: "2012-03-25 10:54:09 UTC")

    
        @item_1 = create(:item, merchant: @merchant_1)
        @item_2 = create(:item, merchant: @merchant_1)
    
        @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 500, status: 1)
        @invoice_item_4 = create(:invoice_item, item: @item_1, invoice: @invoice_3, quantity: 1, unit_price: 500, status: 1)
        @invoice_item_5 = create(:invoice_item, item: @item_1, invoice: @invoice_2, quantity: 1, unit_price: 500, status: 1)
        @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_1, quantity: 1, unit_price: 1000, status: 1)
        @invoice_item_3 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 1000, status: 1)
      end

      it "returns the day that the item sold the most" do
        expect(@item_2.best_day.created_at.strftime("%m/%d/%Y")).to eq("03/26/2012")
      end

      it "can handle multiple invoices with a mix of similar and different days" do
        expect(@item_1.best_day.created_at.strftime("%m/%d/%Y")).to eq("03/25/2012")
      end
    end
  end
end
