require "rails_helper"

RSpec.describe "Bulk Discounts Show Page", type: :feature do
  before(:each) do
    @merchant = create(:merchant)
    @bulk_discount = create(:bulk_discount, merchant_id: @merchant.id)

  end

  describe "As a merchant when I visit the merchant bulk discounts show page" do
    it "I see the bulk discount's quantity threshold and percentage discount" do
        
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@bulk_discount.id}"
      save_and_open_page

      within(".bulk_discounts_show") do
        expect(page).to have_content(@bulk_discount.percentage_discount.to_s)
        expect(page).to have_content(@bulk_discount.threshold.to_s)
      end
    end
  end
end


