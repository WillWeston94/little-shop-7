class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update 
    @invoice = Invoice.find(params[:invoice_id])

    new_status = params[:invoice][:status]
    @invoice.update(status: new_status)
    @invoice.save

    redirect_to "/admin/invoices/#{params[:invoice_id]}", notice: "Invoice status updated!"
  end
end
