namespace :csv_load do
  task :invoices => :environment do
    require 'csv'
    file_path = 'db/data/invoices.csv'
    CSV.foreach(file_path, headers: true) do |row|
      Invoice.create!(customer_id: row['customer_id'], status: row['status'], created_at: row['created_at'], updated_at: row['updated_at']) 
    end
  end
end