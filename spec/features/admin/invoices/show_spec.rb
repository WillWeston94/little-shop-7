require "rails_helper"

RSpec.describe "the admin invoices show page" do
  describe "US33 When I visit an admin invoice show page" do
    xit "I see information related to that invoice including: id, status, created_at date in the format Monday, July 18, 2019, and customer first and last name" do
      customer = create(:customer)
      invoice = Invoice.create!(status: 0, customer_id: customer.id)

      visit "/admin/invoices/#{invoice.id}"

      save_and_open_page

      expect(page).to have_content("ID: #{invoice.id}")
      expect(page).to have_content("STATUS: #{invoice.status}")
      expect(page).to have_content("CREATED AT: #{invoice.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("CUSTOMER NAME: #{customer.first_name} #{customer.last_name}")
    end
  end

  describe "US34 When I visit an admin invoice show page" do
    # NOT YET COMPLETED WITH VIEW ELEMENTS
    xit "I see all of the items on the invoice including: item name, quantity ordered, price item sold for and invoice item status" do
      customer = create(:customer)
      merchant = create(:merchant)
      item_1 = create(:item, merchant_id: merchant.id)
      item_2 = create(:item, merchant_id: merchant.id)
      invoice = Invoice.create!(status: 0, customer_id: customer.id)
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, status: 1, quantity: 2, unit_price: 2)
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, status: 1, quantity: 1, unit_price: 1)

      visit "/admin/invoices/#{invoice.id}"

      expect(page).to have_content("ITEM NAME: #{item_1.name}")
      expect(page).to have_content("QUANTITY: #{invoice_item_1.quantity}")
      expect(page).to have_content("UNIT PRICE: #{invoice_item_1.unit_price}")
      expect(page).to have_content("ITEM STATUS: #{invoice_item_1.status}")

      expect(page).to have_content("ITEM NAME: #{item_2.name}")
      expect(page).to have_content("QUANTITY: #{invoice_item_2.quantity}")
      expect(page).to have_content("UNIT PRICE: #{invoice_item_2.unit_price}")
      expect(page).to have_content("ITEM STATUS: #{invoice_item_2.status}")
    end
  end
end
