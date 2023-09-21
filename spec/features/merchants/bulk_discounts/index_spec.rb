require "rails_helper"

RSpec.describe "Bulk Discounts Index", type: :feature do
  before(:each) do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)

    @bulk_discount_1 = create(:bulk_discount, merchant_id: @merchant_1.id)
    @bulk_discount_2 = create(:bulk_discount, merchant_id: @merchant_1.id)
    @bulk_discount_3 = create(:bulk_discount, merchant_id: @merchant_2.id)
    @bulk_discount_4 = create(:bulk_discount, merchant_id: @merchant_2.id)
  end

  describe "As a merchant when I visit the merchant bulk discounts index page" do
    it "I see all of the bulk discounts for that merchant, including their percentage discount and quantity thresholds, And each bulk discount listed includes a link to its show page" do

      visit merchant_bulk_discounts_path(@merchant_1.id)
      save_and_open_page
      within(".bulk_discounts") do
        expect(page).to have_content(@bulk_discount_1.percentage_discount.to_s)
        expect(page).to have_content(@bulk_discount_1.threshold.to_s)
        expect(page).to have_link(@bulk_discount_1.id) #make it dynamic using href and instances?

        expect(page).to have_content(@bulk_discount_2.percentage_discount.to_s)
        expect(page).to have_content(@bulk_discount_2.threshold.to_s)
        expect(page).to have_link(@bulk_discount_2.id) 

        expect(page).to_not have_content(@bulk_discount_3.percentage_discount.to_s)
        expect(page).to_not have_content(@bulk_discount_3.threshold.to_s)
        expect(page).to_not have_link(@bulk_discount_3.id)
      end
    end
  end
end


