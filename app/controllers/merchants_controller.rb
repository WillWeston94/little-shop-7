class MerchantsController < ApplicationController
  def show
    @merchants = Merchant.find(params[:merchant_id])
    @top_5 = @merchants.customers.order_customers_by_transactions
    @items_to_ship = @merchants.ready_to_ship
  end
end