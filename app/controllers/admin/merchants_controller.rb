class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
    @top_merchants = @merchants.top_revenue
    @enabled_merchants = Merchant.where(disabled: [false, nil])
    @disabled_merchants = Merchant.where(disabled: true)
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])

    if @merchant.update(merchant_params)
      flash[:success] = "Merchant information updated successfully."
      redirect_to admin_merchant_path(@merchant)
    else
      flash[:error] = "Merchant information not updated. Please fill out the entire form."
      redirect_to edit_admin_merchant_path(@merchant)
    end
  end

  def create
    @merchant = Merchant.new(merchant_params)

    if @merchant.save
      flash[:success] = "Merchant created successfully and disabled."
      redirect_to admin_merchants_path
    else
      flash[:error] = "Merchant not created. Please fill out the entire form."
      redirect_to new_admin_merchant_path
    end
  end
  
  def new
    @merchant = Merchant.new
  end

  def disable_enable
    @merchant = Merchant.find(params[:id])
    @merchant.toggle_disabled
    @merchant.save
    notice = @merchant.disabled ? "Merchant #{@merchant.name} disabled." : "Merchant #{@merchant.name} enabled."
    redirect_to '/admin/merchants', notice: notice
  end

  private 

  def merchant_params
    params.require(:merchant).permit(:name)
  end
end