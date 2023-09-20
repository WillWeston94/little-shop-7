class ItemsController < ApplicationController
  
  def edit
    @item = Item.find(params[:id])
  end

  def update
    item = Item.find(params[:id])
    item.update(
      name: params[:name],
      description: params[:description],
      unit_price: params[:unit_price],
      merchant_id: params[:merchant_id]
    )
    item.save
    flash[:success] = "Item information updated successfully."

    redirect_to "/merchants/#{item.merchant_id}/items/#{item.id}"
  end
end