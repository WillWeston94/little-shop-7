require "rails_helper"

RSpec.describe "Admin Merchants Show Page", type: :feature do
  describe "When i click on the name of a merchant from the admin merchant index page" do
    it "I am taken to the admin merchant show page and i see the name of that merchant" do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      visit "/admin/merchants/#{merchant_1.id}"

      expect(page).to have_content(merchant_1.name)
      expect(page).to_not have_content(merchant_2.name)
    end
  end

  describe "When i visit the admin merchant show page" do
    it "I see a link to edit the merchant's information" do
      merchant_1 = create(:merchant)

      visit "/admin/merchants/#{merchant_1.id}"

      expect(page).to have_link("Edit Merchant")
    end
  end
end
