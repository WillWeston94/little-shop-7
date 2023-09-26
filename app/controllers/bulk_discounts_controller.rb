class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = @merchant.bulk_discounts.new(bulk_discount_params)

    if @bulk_discount.save
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts", notice: "Bulk discount created successfully"
    else
      flash[:error] = "Please fill in all fields"
      render :new
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.destroy

    redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts", notice: "Bulk discount deleted successfully"
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])

    if @bulk_discount.update(bulk_discount_params)
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts", notice: "Bulk discount updated successfully"
    else
      flash[:error] = "Discount must be between 0.01 and 0.99"
      render :edit
    end
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :threshold)
  end
end
