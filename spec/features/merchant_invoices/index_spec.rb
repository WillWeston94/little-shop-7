require "rails_helper"

RSpec.describe "the merchant's invoice index" do

  describe "complete invoices list" do
    it "lists all invoice id's in the system that have an item" do
      
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @customer_1 = create(:customer)
      
      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_1)
      @item_3 = create(:item, merchant: @merchant_2)
    
      @invoice_1 = create(:invoice, customer_id: @customer_1.id)
      @invoice_2 = create(:invoice, customer_id: @customer_1.id)
      @invoice_3 = create(:invoice, customer_id: @customer_1.id)
    
      @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id)
      @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id)
      @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id)

      visit "/merchants/#{@merchant_1.id}/invoices"

      expect(page).to have_link("#{@invoice_1.id}", href: "/merchants/#{@merchant_1.id}/invoices/#{@invoice_1.id}")
      expect(page).to have_link("#{@invoice_2.id}", href: "/merchants/#{@merchant_1.id}/invoices/#{@invoice_2.id}")
      expect(page).not_to have_link("#{@invoice_3.id}")
    end
  end
end