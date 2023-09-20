require 'rails_helper'

RSpec.describe "admin/merchants new page", type: :feature do
  describe "When I visit the admin/merchants new page" do
    it "I can fill in a form to create a new merchant" do
      visit "/admin/merchants/new"

      expect(page).to have_field("merchant_name")
      expect(page).to have_button("Submit")
      fill_in "merchant_name", with: "I'm a new Merchant"
      click_button("Submit")

      expect(page).to have_current_path("/admin/merchants")

      expect(page).to have_content("I'm a new Merchant")
    end

    it "displays an error if the form is not filled out" do
      visit "/admin/merchants/new"

      click_button("Submit")
      expect(page).to have_current_path("/admin/merchants/new")
      expect(page).to have_content("Merchant not created. Please fill out the entire form.")
    end
  end
end