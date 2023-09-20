class Admin::DashboardController < ApplicationController
  def index
    @customers = Customer.all
    @ordered_customers = @customers.order_customers_by_transactions
    @invoices = Invoice.all
    @incomplete_invoices = @invoices.not_fulfilled
  end
end
