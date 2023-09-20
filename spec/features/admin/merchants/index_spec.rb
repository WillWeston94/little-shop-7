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
end
