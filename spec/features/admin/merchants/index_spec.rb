require "rails_helper"

RSpec.describe "Admin Merchants Index Page", type: :feature do
  describe "empty merchant index page" do
    it "can display a message when there are no merchants" do
      visit "/admin/merchants"

      expect(page).to have_content("No Merchants Found")
    end
  end

  describe "complete merchant list" do
    it "can list all merchants" do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant, disabled: true)
      @merchant_4 = create(:merchant, disabled: true)

      visit "/admin/merchants"

      expect(page).to have_content(@merchant_1.name)
      expect(page).to have_content(@merchant_2.name)
      expect(page).to have_content(@merchant_3.name)
      expect(page).to have_content(@merchant_4.name)
    end
  end

  describe "merchant index list has button to disable merchant" do
    it "when clicked can disable a merchant" do
      @merchant_1 = create(:merchant)

      visit "/admin/merchants"

      within("#enabled_merchants-#{@merchant_1.id}") do
        expect(page).to have_button("Disable")
        click_button("Disable")
      end

      expect(current_path).to eq("/admin/merchants")
      within("#disabled_merchants-#{@merchant_1.id}") do
        expect(page).to have_button("Enable")
      end
    end
  end

  describe "merchant index list has two sections" do
    before do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @merchant_3 = create(:merchant, disabled: true)
      @merchant_4 = create(:merchant, disabled: true)

      visit "/admin/merchants"
    end

    it "can list all enabled merchants and all disabled merchants" do
      within("#enabled_merchants") do
        expect(page).to have_content(@merchant_1.name)
        expect(page).to have_content(@merchant_2.name)
        expect(page).to_not have_content(@merchant_3.name)
        expect(page).to_not have_content(@merchant_4.name)
        expect(page).to have_button("Disable")
      end
    end

    it "can list all disabled merchants" do
      within("#disabled_merchants") do
        expect(page).to_not have_content(@merchant_1.name)
        expect(page).to_not have_content(@merchant_2.name)
        expect(page).to have_content(@merchant_3.name)
        expect(page).to have_content(@merchant_4.name)
        expect(page).to have_button("Enable")
      end
    end
  end

  describe "merchant index shows top 5 merchants by revenue" do
    it "shows the top 5 merchants by revenue as well as their best day" do
      merchant_5 = create(:merchant)
      merchant_6 = create(:merchant)
      merchant_7 = create(:merchant)
      merchant_8 = create(:merchant)
      merchant_9 = create(:merchant)
      merchant_10 = create(:merchant)

      customer_5 = create(:customer)
      customer_6 = create(:customer)
      customer_7 = create(:customer)
      customer_8 = create(:customer)
      customer_9 = create(:customer)
      customer_10 = create(:customer)

      item_5 = create(:item, merchant: merchant_5)
      item_6 = create(:item, merchant: merchant_6)
      item_7 = create(:item, merchant: merchant_7)
      item_8 = create(:item, merchant: merchant_8)
      item_9 = create(:item, merchant: merchant_9)
      item_10 = create(:item, merchant: merchant_10)

      invoice_5 = create(:invoice, customer: customer_5)
      invoice_6 = create(:invoice, customer: customer_6, created_at: "2021-04-01 14:54:05 UTC")
      invoice_7 = create(:invoice, customer: customer_7, created_at: "2021-04-06 10:11:05 UTC")
      invoice_8 = create(:invoice, customer: customer_8, created_at: "2021-04-10 14:54:05 UTC")
      invoice_9 = create(:invoice, customer: customer_9, created_at: "2021-04-15 14:54:05 UTC")
      invoice_10 = create(:invoice, customer: customer_10, created_at: "2021-04-20 14:54:05 UTC")

      invoice_item_5 = create(:invoice_item, item: item_5, invoice: invoice_5, quantity: 1, unit_price: 5000)
      invoice_item_6 = create(:invoice_item, item: item_6, invoice: invoice_6, quantity: 1, unit_price: 6000)
      invoice_item_7 = create(:invoice_item, item: item_7, invoice: invoice_7, quantity: 1, unit_price: 7000)
      invoice_item_8 = create(:invoice_item, item: item_8, invoice: invoice_8, quantity: 1, unit_price: 8000)
      invoice_item_9 = create(:invoice_item, item: item_9, invoice: invoice_9, quantity: 1, unit_price: 9000)
      invoice_item_10 = create(:invoice_item, item: item_10, invoice: invoice_10, quantity: 1, unit_price: 10000)

      transaction_5 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_6 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_7 = create(:transaction, invoice: invoice_7, result: 1)
      transaction_8 = create(:transaction, invoice: invoice_8, result: 1)
      transaction_9 = create(:transaction, invoice: invoice_9, result: 1)
      transaction_10 = create(:transaction, invoice: invoice_10, result: 1)

      visit "/admin/merchants"

      within("#top_merchants") do
        expect(page).to have_content(merchant_10.name)
        expect(page).to have_content("2021-04-20")
        expect(page).to have_content(merchant_9.name)
        expect(page).to have_content("2021-04-15")
        expect(page).to have_content(merchant_8.name)
        expect(page).to have_content("2021-04-10")
        expect(page).to have_content(merchant_7.name)
        expect(page).to have_content("2021-04-06")
        expect(page).to have_content(merchant_6.name)
        expect(page).to have_content("2021-04-01")
        expect(page).to_not have_content(merchant_5.name)
      end
    end
  end
end
