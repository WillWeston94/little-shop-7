Merchant.destroy_all
Item.destroy_all
Invoice.destroy_all
InvoiceItem.destroy_all
Transaction.destroy_all
Customer.destroy_all
Rake::Task["load_csv:all"].invoke