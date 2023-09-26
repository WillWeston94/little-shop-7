class CreateHolidayDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :holiday_discounts do |t|
      t.date :date
      t.string :name
      t.decimal :percentage_discount
      t.integer :threshold
      t.references :merchant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
