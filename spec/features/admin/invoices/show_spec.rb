require "rails_helper"

RSpec.describe "the admin invoices show page" do
  describe "US33 admin invoice show page" do
    it "I see information related to that invoice including: id, status, created_at date in the format Monday, July 18, 2019, and customer first and last name" do
      customer = create(:customer)
      invoice = Invoice.create!(status: 0, customer_id: customer.id)

      visit "/admin/invoices/#{invoice.id}"

      expect(page).to have_content("ID: #{invoice.id}")
      expect(page).to have_content("STATUS: #{invoice.status}")
      expect(page).to have_content("CREATED AT: #{invoice.created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to have_content("CUSTOMER NAME: #{customer.first_name} #{customer.last_name}")
    end
  end

  describe "US34 admin invoice show page" do
    it "I see all of the items on the invoice including: item name, quantity ordered, price item sold for and invoice item status" do
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
      expect(page).to have_content(/UNIT PRICE: \$\d+\.\d{2}/)
      # Correct calc, temp solution?
      expect(page).to have_content("ITEM STATUS: #{invoice_item_1.status}")

      expect(page).to have_content("ITEM NAME: #{item_2.name}")
      expect(page).to have_content("QUANTITY: #{invoice_item_2.quantity}")
      expect(page).to have_content(/UNIT PRICE: \$\d+\.\d{2}/)
      # Correct calc, temp solution?
      expect(page).to have_content("ITEM STATUS: #{invoice_item_2.status}")
    end
  end

  describe "US 35 admin invoice show page" do
    it "I see the total revenue that will be generated from the invoice" do
      customer = create(:customer)
      merchant = create(:merchant)
      item_1 = create(:item, merchant_id: merchant.id)
      item_2 = create(:item, merchant_id: merchant.id)
      invoice = Invoice.create!(status: 0, customer_id: customer.id)

      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, status: 1, quantity: 2, unit_price: 2)

      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, status: 1, quantity: 1, unit_price: 1)

      visit "/admin/invoices/#{invoice.id}"

      expect(page).to have_content(/Total Revenue for Invoice #{invoice.id} is: \$\d+\.\d{2}/)
      # Correct calc, temp solution?
    end
  end

  describe "US 36 admin invoice show page" do
    describe "I see the invoice status is a select field and I see that the invoice's current status is selected when I click this select field" do
      describe "then I can select a new status for the Invoice, and next to the select field I see a button to 'Update Invoice Status'" do
        it "When I click this button I am taken back to the admin invoice show page and I see that my Invoice's status has now been updated" do
          customer = create(:customer)
          merchant = create(:merchant)
          item_1 = create(:item, merchant_id: merchant.id)
          item_2 = create(:item, merchant_id: merchant.id)
          invoice = Invoice.create!(status: 0, customer_id: customer.id)

          invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice.id, status: 1, quantity: 2, unit_price: 2)

          invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice.id, status: 1, quantity: 1, unit_price: 1)

          visit "/admin/invoices/#{invoice.id}"

          within("#invoice_status_form") do
            expect(page).to have_select("invoice_status", selected: invoice.status)
            page.select("completed")
            click_button("Update Invoice Status")
          end

          expect(page).to have_current_path("/admin/invoices/#{invoice.id}")

          expect(page).to have_content("STATUS: completed")
        end
      end
    end
  end
end
