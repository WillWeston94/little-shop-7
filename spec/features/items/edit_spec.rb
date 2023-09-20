require 'rails_helper'

RSpec.describe "Items Edit", type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @item_1 = create(:item, merchant_id: @merchant_1.id, unit_price: 1234)
    @item_2 = create(:item, merchant_id: @merchant_1.id)
    @item_3 = create(:item, merchant_id: @merchant_1.id)
    @item_4 = create(:item, merchant_id: @merchant_1.id)
    @item_5 = create(:item, merchant_id: @merchant_2.id)
    @item_6 = create(:item, merchant_id: @merchant_2.id)
    @item_7 = create(:item, merchant_id: @merchant_2.id)
    @item_8 = create(:item, merchant_id: @merchant_2.id)
    @item_9 = create(:item, merchant_id: @merchant_2.id)
  end

  describe "When I visit the items edit page" do
    it "opens a form to edit the item" do
      visit "/items/#{@item_1.id}/edit"

      expect(page).to have_field("name")
      expect(page).to have_field("description")
      expect(page).to have_field("unit_price")
      expect(page).to have_field("merchant_id")
      expect(page).to have_button("Update Item")
    end

    it "updates the item and returns the user to the item show page when the form is submitted" do
      visit "/items/#{@item_1.id}/edit"
      
      fill_in "name", with: "Updated Name"
      fill_in "description", with: "Updated Description"
      fill_in "unit_price", with: "10234"
      fill_in "merchant_id", with: "#{@merchant_1.id}"
      click_button "Update Item"

      expect(page).to have_current_path("/merchants/#{@merchant_1.id}/items/#{@item_1.id}")

      expect(page).to have_content("Name: Updated Name")
      expect(page).to have_content("Description: Updated Description")
      expect(page).to have_content("Unit price: $102.34")
      expect(page).to have_content("Merchant ID: #{@merchant_1.id}")
      expect(page).to have_content("Item information updated successfully.")
    end
  end
end