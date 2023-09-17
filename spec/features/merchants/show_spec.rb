require "rails_helper"

RSpec.describe "merchant#show" do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    @item_1 = create(:item, merchant_id: @merchant_1.id, unit_price: 1234)
    @item_2 = create(:item, merchant_id: @merchant_1.id)
    @item_3 = create(:item, merchant_id: @merchant_1.id)
    @item_4 = create(:item, merchant_id: @merchant_1.id)
    @item_5 = create(:item, merchant_id: @merchant_2.id)
    @item_6 = create(:item, merchant_id: @merchant_2.id)
    @item_7 = create(:item, merchant_id: @merchant_2.id)
    @item_8 = create(:item, merchant_id: @merchant_2.id)
    @item_9 = create(:item, merchant_id: @merchant_2.id)
    @invoice_1 = create(:invoice, customer_id: @customer_1.id)
    @invoice_2 = create(:invoice, customer_id: @customer_1.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id , status: "packaged")
  end

  describe "display merchant info" do
    it "has merchant info listed " do
      visit "/merchants/#{@merchant_1.id}/dashboard"
      
      within("#merchant_info-#{@merchant_1.id}") do 
        expect(page).to have_content(@merchant_1.name)
      end
    end

    it "has links to a merchant's items and invoices" do
      visit "/merchants/#{@merchant_1.id}/dashboard"

      within("#items_index-#{@merchant_1.id}") do
        expect(page).to have_link("Items")
      end
      within("#invoices_index-#{@merchant_1.id}") do
        expect(page).to have_link("Invoices")
      end
    end
  end

  describe "merchant top 5 customers" do 
    it "shows the top 5 customers with the largest successful transactions with this merchant" do
      visit "/merchants/#{@merchant_1.id}/dashboard"
      
        expect(page).to have_content(@customer_1.first_name)
        expect(page).to have_content(@customer_2.first_name)
        expect(page).to have_content(@customer_3.first_name)
        expect(page).to have_content(@customer_4.first_name)
        expect(page).to have_content(@customer_5.first_name)

        expect(page).to have_content(@customer_1.amount_of_transactions)
        expect(page).to have_content(@customer_2.amount_of_transactions)
        expect(page).to have_content(@customer_3.amount_of_transactions)
        expect(page).to have_content(@customer_4.amount_of_transactions)
        expect(page).to have_content(@customer_5.amount_of_transactions)
    end
  end

  describe "merchant items ready to ship" do
    it "has a list of items that have been ordered and not yet shipped" do
      visit "/merchants/#{@merchant_1.id}/dashboard"

      within("#items_to_ship-#{@merchants.id}") do
        expect(page).to have_content(@item_1.name)
      end

    end


    #not sure if this will work and I can't check until I get a working method
    
    # it "displays the id of the invoice for the ordered item and a link to the merchant's invoice show page" do
    #   visit "/merchants/#{@merchant_1.id}/dashboard"

    #   within("#items_to_ship-#{@merchants.id}") do
    #   expect(page).to have_link("#{@item_1.invoice.id}")

    # end


  end
end