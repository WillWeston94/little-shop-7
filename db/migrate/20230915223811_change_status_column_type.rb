
class ChangeStatusColumnType < ActiveRecord::Migration[6.0] # Use your Rails version
  def change
    change_column :invoices, :status, :integer, using: 'status::integer'
  end
end
