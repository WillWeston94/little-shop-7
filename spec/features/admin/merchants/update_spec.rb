require "rails_helper"

RSpec.describe "Admin Merchants Update Page", type: :feature do
  describe "And I see a form filled in with the existing merchant attribute information" do
    it "When I fill out the form with a new name and click submit, I am redirected to the admin merchant show page and I see the merchant's updated information" do
      brown_inc = Merchant.create!(name: "Brown Inc")

      visit "/admin/merchants/#{brown_inc.id}/edit"

      fill_in "Name", with: "Brown Inc - TEST."

      click_button "Submit"

      expect(page).to have_content("Merchant information updated successfully.")
      expect(page).to have_content("Brown Inc - TEST.")
    end

    it "throws an error message when the form is not filled out completely" do
      brown_inc = Merchant.create!(name: "Brown Inc")

      visit "/admin/merchants/#{brown_inc.id}/edit"

      fill_in "Name", with: ""
      click_button "Submit"

      expect(page).to have_current_path("/admin/merchants/#{brown_inc.id}/edit")
      expect(page).to have_content("Merchant information not updated. Please fill out the entire form.")
    end
  end
end