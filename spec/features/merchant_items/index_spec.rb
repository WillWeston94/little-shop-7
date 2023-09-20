require 'rails_helper'

RSpec.describe "MerchantItems Index", type: :feature do
  
  describe "When I visit the merchantitems index page" do
    before(:each) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @item_1 = create(:item, merchant_id: @merchant_1.id)
      @item_2 = create(:item, merchant_id: @merchant_1.id)
      @item_3 = create(:item, merchant_id: @merchant_1.id, status: 0)
      @item_4 = create(:item, merchant_id: @merchant_1.id, status: 0)
      @item_5 = create(:item, merchant_id: @merchant_2.id)
      @item_6 = create(:item, merchant_id: @merchant_2.id)
      @item_7 = create(:item, merchant_id: @merchant_2.id)
      @item_8 = create(:item, merchant_id: @merchant_2.id)
      @item_9 = create(:item, merchant_id: @merchant_2.id)
    end

    it "I see a list of all items associated with the current merchant, without items for other merchants" do
      visit "/merchants/#{@merchant_1.id}/items"

      expect(page).to have_content(@item_1.name)
      expect(page).to have_content(@item_2.name)
      expect(page).to have_content(@item_3.name)
      expect(page).to have_content(@item_4.name)
      expect(page).to_not have_content(@item_5.name)
      expect(page).to_not have_content(@item_6.name)
      expect(page).to_not have_content(@item_7.name)
      expect(page).to_not have_content(@item_8.name)
      expect(page).to_not have_content(@item_9.name)
    end

    it "each listed item links to that items show page" do
      visit "/merchants/#{@merchant_1.id}/items"

      within("#item-#{@item_1.id}") do
        expect(page).to have_link("#{@item_1.name}", href: "/merchants/#{@merchant_1.id}/items/#{@item_1.id}")
        click_link("#{@item_1.name}")
      end

      expect(page).to have_current_path("/merchants/#{@merchant_1.id}/items/#{@item_1.id}")
    end

    it "each item has a button to enable or disable it, and clicking it performs that action" do
      visit "/merchants/#{@merchant_1.id}/items"

      within("#item-#{@item_1.id}") do
        expect(page).to have_button("Disable Item")
        click_button("Disable Item")
      end

      expect(page).to have_current_path("/merchants/#{@merchant_1.id}/items")

      within("#item-#{@item_1.id}") do
        expect(page).to have_button("Enable Item")
        click_button("Enable Item")
      end

      expect(page).to have_current_path("/merchants/#{@merchant_1.id}/items")

      within("#item-#{@item_1.id}") do
        expect(page).to have_button("Disable Item")
      end
    end

    it "items are split into two sections, one for enabled items and one for disabled items" do
      visit "/merchants/#{@merchant_1.id}/items"

      within("#status-enabled") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@item_2.name)
        expect(page).to_not have_content(@item_3.name)
        expect(page).to_not have_content(@item_4.name)
      end

      within("#status-disabled") do
        expect(page).to_not have_content(@item_1.name)
        expect(page).to_not have_content(@item_2.name)
        expect(page).to have_content(@item_3.name)
        expect(page).to have_content(@item_4.name)
      end
    end

    it "has a link to create a new item" do
      visit "/merchants/#{@merchant_1.id}/items"

      expect(page).to have_link("Create an Item", href: "/merchants/#{@merchant_1.id}/items/new")
    end
  end

  context "popular items" do
    before(:each) do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
  
      @customer_1 = create(:customer)
      @customer_2 = create(:customer)
  
      @invoice_1 = create(:invoice, customer: @customer_1, created_at: "2012-03-25 09:54:09 UTC")
      @invoice_2 = create(:invoice, customer: @customer_1, created_at: "2012-03-26 09:54:09 UTC")
      @invoice_3 = create(:invoice, customer: @customer_2)
      @invoice_4 = create(:invoice, customer: @customer_2)
  
      @item_1 = create(:item, merchant: @merchant_1)
      @item_2 = create(:item, merchant: @merchant_1) #
      @item_3 = create(:item, merchant: @merchant_1) #
      @item_4 = create(:item, merchant: @merchant_1)
      @item_5 = create(:item, merchant: @merchant_1) #
      @item_6 = create(:item, merchant: @merchant_1) #
      @item_7 = create(:item, merchant: @merchant_1) #
      @item_8 = create(:item, merchant: @merchant_2)
      @item_9 = create(:item, merchant: @merchant_2)
  
      @invoice_item_1 = create(:invoice_item, item: @item_1, invoice: @invoice_1, quantity: 1, unit_price: 500, status: 1)
      @invoice_item_2 = create(:invoice_item, item: @item_2, invoice: @invoice_1, quantity: 1, unit_price: 1000, status: 1)
      @invoice_item_3 = create(:invoice_item, item: @item_2, invoice: @invoice_2, quantity: 3, unit_price: 1000, status: 1)
      @invoice_item_4 = create(:invoice_item, item: @item_3, invoice: @invoice_2, quantity: 2, unit_price: 1500, status: 1)
      @invoice_item_5 = create(:invoice_item, item: @item_4, invoice: @invoice_2, quantity: 10, unit_price: 40, status: 1)
      @invoice_item_6 = create(:invoice_item, item: @item_5, invoice: @invoice_1, quantity: 1, unit_price: 1000, status: 1)
      @invoice_item_7 = create(:invoice_item, item: @item_6, invoice: @invoice_1, quantity: 7, unit_price: 500, status: 1)
      @invoice_item_8 = create(:invoice_item, item: @item_7, invoice: @invoice_1, quantity: 4, unit_price: 1200, status: 1)
      # item2 = 4000, item3 = 3000, item5 = 1000, item6 = 3500, item7 = 4800 || item1 = 500, item4 = 400
      @invoice_item_9 = create(:invoice_item, item: @item_8, invoice: @invoice_3, quantity: 10, unit_price: 1200, status: 1)
      @invoice_item_10 = create(:invoice_item, item: @item_9, invoice: @invoice_4, quantity: 7, unit_price: 1000, status: 1)
    end

    it "displays the top 5 most popular items, ranked by total revenue generated, and displays that revenue" do

      visit "/merchants/#{@merchant_1.id}/items"

      within("#popular-items") do
        expect(page).to have_link(@item_2.name)
        expect(page).to have_link(@item_3.name)
        expect(page).to have_link(@item_5.name)
        expect(page).to have_link(@item_6.name)
        expect(page).to have_link(@item_7.name)

        expect(@item_7.name).to appear_before(@item_2.name)
        expect(@item_2.name).to appear_before(@item_6.name)
        expect(@item_6.name).to appear_before(@item_3.name)
        expect(@item_3.name).to appear_before(@item_5.name)

        expect(page).to have_content("#{@item_7.name} - Total revenue: $48.00")
        expect(page).to have_content("#{@item_2.name} - Total revenue: $40.00")
        expect(page).to have_content("#{@item_6.name} - Total revenue: $35.00")
        expect(page).to have_content("#{@item_3.name} - Total revenue: $30.00")
        expect(page).to have_content("#{@item_5.name} - Total revenue: $10.00")
      end
    end

    it "displays the best day for each of the most popular items" do
      visit "/merchants/#{@merchant_1.id}/items"

      expect(page).to have_content(("#{@item_7.name} - Total revenue: $48.00 - Top selling date: 03/25/2012"))
      expect(page).to have_content(("#{@item_2.name} - Total revenue: $40.00 - Top selling date: 03/26/2012"))
      expect(page).to have_content(("#{@item_6.name} - Total revenue: $35.00 - Top selling date: 03/25/2012"))
      expect(page).to have_content(("#{@item_3.name} - Total revenue: $30.00 - Top selling date: 03/26/2012"))
      expect(page).to have_content(("#{@item_5.name} - Total revenue: $10.00 - Top selling date: 03/25/2012"))
    end
  end
end