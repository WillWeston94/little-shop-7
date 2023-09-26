class HolidayDiscount < ApplicationRecord
  belongs_to :merchant

  validates :percentage_discount, presence: true
  validates :threshold, presence: true
  validates :name, presence: true
  validates :date, presence: true

end
