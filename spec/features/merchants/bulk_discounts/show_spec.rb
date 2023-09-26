require "rails_helper"

RSpec.describe "Bulk Discounts Show Page", type: :feature do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discount = create(:bulk_discount, merchant_id: @merchant.id)

  end

  describe "As a merchant when I visit the merchant bulk discounts show page" do
    it "I see the bulk discount's quantity threshold and percentage discount" do
        
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}"


      within(".bulk_discounts_show") do
        expect(page).to have_content((@bulk_discount.percentage_discount * 100 ).to_s)
        expect(page).to have_content(@bulk_discount.threshold.to_s)
      end
    end
  end

  describe "As a merchant when I visit the merchant bulk discounts show page" do
    it "I see a link to edit the bulk discount and I am taken to a new page where I fill in a form to edit the discount and I am redirected back to the bulk discount show page" do
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}"

      expect(page).to have_link("Edit Discount")

      click_link "Edit Discount"
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant.id, @bulk_discount.id))

      fill_in "Percentage discount", with: 10
      fill_in "Threshold", with: 10
      click_button "Submit"
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @bulk_discount.id))
      expect(page).to have_content("Discount must be between 0.01 and 0.99")
      
      fill_in "Percentage discount", with: 0.10
      fill_in "Threshold", with: 10
      click_button "Submit"

      expect(current_path).to eq("/merchants/#{@merchant.id}/bulk_discounts")
      expect(page).to have_content("Bulk discount updated successfully")
    end
  end
end


