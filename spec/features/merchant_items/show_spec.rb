require "rails_helper"

RSpec.describe "MerchantItems Show", type: :feature do
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

  describe "When I visit the merchantitems show page" do
    it "I see all of the items attributes including name, description, and current selling price" do
      visit "/merchants/#{@merchant_1.id}/items/#{@item_1.id}"

      expect(page).to have_content("Name: #{@item_1.name}")
      expect(page).to have_content("Description: #{@item_1.description}")
      expect(page).to have_content("Unit price: $12.34")
    end

    it "has a link to update that item" do
      visit "/merchants/#{@merchant_1.id}/items/#{@item_1.id}"

      expect(page).to have_link("Update Item", href: "/items/#{@item_1.id}/edit")
    end
  end
end
