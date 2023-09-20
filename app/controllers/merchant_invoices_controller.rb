class MerchantInvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.group(:id)
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:invoice_id])
    @specific_invoice_items = @invoice.invoice_items.merchant_specific(@merchant)
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:invoice_id])
    @specific_invoice_items = @invoice.invoice_items.merchant_specific(@merchant)

    invoice_item = @specific_invoice_items.find(params[:invoice_item][:invoice_item_id])

    new_status = params[:invoice_item][:status]
    invoice_item.update(status: new_status)
    invoice_item.save

    redirect_to "/merchants/#{params[:merchant_id]}/invoices/#{params[:invoice_id]}", notice: "Item status updated successfully."
  end

  def invoice_params
    params.require(:invoice_item).permit(:status, :invoice_item_id)
  end
end
