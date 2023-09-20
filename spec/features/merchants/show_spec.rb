require "rails_helper"

RSpec.describe "merchant#show" do
  before :each do
    @merchant_1 = create(:merchant)
    @customer_1 = create(:customer)
    @customer_2 = create(:customer)
    @customer_3 = create(:customer)
    @customer_4 = create(:customer)
    @customer_5 = create(:customer)
    
    @item_1 = create(:item, merchant_id: @merchant_1.id)
    @item_2 = create(:item, merchant_id: @merchant_1.id)
    @item_3 = create(:item, merchant_id: @merchant_1.id)
    @item_4 = create(:item, merchant_id: @merchant_1.id)
    @item_5 = create(:item, merchant_id: @merchant_1.id)

    @invoice_1 = create(:invoice, customer_id: @customer_1.id, created_at: "2012-03-25 09:54:09 UTC")
    @invoice_2 = create(:invoice, customer_id: @customer_2.id, created_at: "2012-03-26 09:54:09 UTC")
    @invoice_3 = create(:invoice, customer_id: @customer_3.id, created_at: "2012-03-27 09:54:09 UTC")
    @invoice_4 = create(:invoice, customer_id: @customer_4.id, created_at: "2012-03-28 09:54:09 UTC")
    @invoice_5 = create(:invoice, customer_id: @customer_5.id)

    @invoice_item_1 = create(:invoice_item, item_id: @item_1.id, invoice_id: @invoice_1.id, status: 1)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, status: 1)
    @invoice_item_3 = create(:invoice_item, item_id: @item_3.id, invoice_id: @invoice_3.id, status: 1)
    @invoice_item_4 = create(:invoice_item, item_id: @item_4.id, invoice_id: @invoice_4.id, status: 1)
    @invoice_item_5 = create(:invoice_item, item_id: @item_5.id, invoice_id: @invoice_5.id, status: 1)

    @transaction_1 = create(:transaction, invoice_id: @invoice_1.id, result: 1)
    @transaction_2 = create(:transaction, invoice_id: @invoice_2.id, result: 1)
    @transaction_3 = create(:transaction, invoice_id: @invoice_3.id, result: 1)
    @transaction_4 = create(:transaction, invoice_id: @invoice_4.id, result: 1)
    @transaction_5 = create(:transaction, invoice_id: @invoice_5.id, result: 1)
  end
  
  describe "display merchant info" do

    it "has merchant info listed " do
      merchant_1 = create(:merchant)

      visit "/merchants/#{merchant_1.id}/dashboard"
      
      within("#merchant_info-#{merchant_1.id}") do 
        expect(page).to have_content(merchant_1.name)
      end
    end

    it "has links to a merchant's items and invoices" do
      merchant_1 = create(:merchant)

      visit "/merchants/#{merchant_1.id}/dashboard"

      within("#items_index-#{merchant_1.id}") do
        expect(page).to have_link("Items")
      end
      within("#invoices_index-#{merchant_1.id}") do
        expect(page).to have_link("Invoices")
      end
    end
  end

  describe "merchant top 5 customers" do 
    it "shows the top 5 customers with the largest successful transactions with this merchant" do

      visit "/merchants/#{@merchant_1.id}/dashboard"
     
      within("#top_five_customers-#{@merchant_1.id}") do
        expect(page).to have_content(@customer_1.first_name)
        expect(page).to have_content("#{@customer_1.first_name} #{@customer_1.last_name} (#{@customer_1.amount_of_transactions}Transactions)")
        expect(page).to have_content("#{@customer_2.first_name} #{@customer_2.last_name} (#{@customer_2.amount_of_transactions}Transactions)")
        expect(page).to have_content("#{@customer_3.first_name} #{@customer_3.last_name} (#{@customer_3.amount_of_transactions}Transactions)")
        expect(page).to have_content("#{@customer_4.first_name} #{@customer_4.last_name} (#{@customer_4.amount_of_transactions}Transactions)")
        expect(page).to have_content("#{@customer_5.first_name} #{@customer_5.last_name} (#{@customer_5.amount_of_transactions}Transactions)")
      end
    end
  end

  describe "merchant items ready to ship" do
    it "has a list of items that have been ordered and not yet shipped" do
    
      visit "/merchants/#{@merchant_1.id}/dashboard"

      within("#items_to_ship-#{@merchant_1.id}") do
        expect(page).to have_content(@item_1.name)
      end

    end

    it "displays the id of the invoice for the ordered item and a link to the merchant's invoice show page" do
      
      visit "/merchants/#{@merchant_1.id}/dashboard"
  
      within("#items_to_ship-#{@merchant_1.id}") do
        expect(page).to have_content(@invoice_1.id)
        expect(page).to have_link(@invoice_1.id)
      end
    end

    it "see the date formatted and I see that the list is ordered from oldest to newest" do
      visit "/merchants/#{@merchant_1.id}/dashboard"
      save_and_open_page

      within("#items_to_ship-#{@merchant_1.id}") do
        expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
        expect(@item_1.name).to appear_before(@item_2.name, only_text: true)
        expect(@item_2.name).to appear_before(@item_3.name, only_text: true)
        expect(@item_3.name).to appear_before(@item_4.name, only_text: true)
      end

    end
  end
end