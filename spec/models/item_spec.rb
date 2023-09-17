require "rails_helper"

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:description) }
  end

  describe "#unit_price_formatted" do
    it "can convert unit_price to dollars" do
      item = Item.new(unit_price: 12345)
      expect(item.unit_price_formatted).to eq(123.45)
    end

    it "can handle zero" do
      item = Item.new(unit_price: 0)
      expect(item.unit_price_formatted).to eq(0)
    end
  end

  describe "#ready_to_ship" do
    it "can display items with a status of 'packaged'" do
    
    end
  end
end
