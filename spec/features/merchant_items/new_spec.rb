require "rails_helper"

RSpec.describe "Merchant Items New", type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
  end

  describe "When I visit the merchant items new page" do
    it "I see a form to create a new item" do
      visit "/merchants/#{@merchant_1.id}/items/new"

      expect(page).to have_field("name")
      expect(page).to have_field("description")
      expect(page).to have_field("unit_price")
      expect(page).to have_button("Create Item")
    end

    it "submitting the form creates a new item and takes me to the merchant items index page" do
      visit "/merchants/#{@merchant_1.id}/items/new"

      fill_in("name", with: "Test Item")
      fill_in("description", with: "Test Description")
      fill_in("unit_price", with: 10234)
      click_button("Create Item")

      expect(page).to have_current_path("/merchants/#{@merchant_1.id}/items")
      expect(page).to have_content("Test Item")
    end

    it "submitting the form creates the item with a default status of disabled" do
      visit "/merchants/#{@merchant_1.id}/items/new"

      fill_in("name", with: "Test Item")
      fill_in("description", with: "Test Description")
      fill_in("unit_price", with: 10234)
      click_button("Create Item")

      within("#status-disabled") do
        expect(page).to have_content("Test Item")
      end

      within("#status-enabled") do
        expect(page).to_not have_content("Test Item")
      end
    end
  end
end
