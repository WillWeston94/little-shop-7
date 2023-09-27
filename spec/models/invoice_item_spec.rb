require "rails_helper"

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "validations" do
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:status) }
  end

  describe "#merchant_specific" do
    it "returns items only appropriate to the correct merchant" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @customer_1 = create(:customer)

      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_2.id)
      @item_3 = create(:item, merchant_id: @merchant_1.id)

      @invoice_1 = create(:invoice, customer_id: @customer_1.id)

      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 2)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_1.id)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_1.id)

      expect(@invoice_1.invoice_items.merchant_specific(@merchant_1)).to eq([@invoice_item_1, @invoice_item_3])
    end
  end

  describe "#discounted_revenue" do
    it "returns the discounted revenue for the invoice" do
      @merchant_1 = create(:merchant)
      @customer_1 = create(:customer)

      @item_1 = create(:item, merchant_id: @merchant_1.id)

      @invoice_1 = create(:invoice, customer_id: @customer_1.id)

      @bulk_discount_1 = create(:bulk_discount, merchant_id: @merchant_1.id, threshold: 2, percentage_discount: 0.10)

      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 2, unit_price: 10)
      @invoice_item_2 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, quantity: 1, unit_price: 10)

      discounted_revenue = @invoice_1.invoice_items.sum(&:discounted_revenue)

      expect(discounted_revenue).to eq(0.28e2)
    end
  end
end
