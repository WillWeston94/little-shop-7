class HolidayDiscountsController < ApplicationController
  def index
    render json: HolidayDiscount.all
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @holiday_discount = HolidayDiscount.new
    @holiday_discount.name = params[:name]
    @holiday_discount.date = params[:date]
    @holiday_discount.percentage_discount = params[:percentage_discount]
    @holiday_discount.threshold = params[:threshold]
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @holiday_discount = @merchant.holiday_discounts.new(holiday_discount_params)
    if @holiday_discount.save
      redirect_to "/merchants/#{params[:merchant_id]}/bulk_discounts", notice: "Holiday discount created successfully"
    else
      render :new
    end
  end

  private 

  def holiday_discount_params
    params.require(:holiday_discount).permit(:percentage_discount, :threshold)
  end
end