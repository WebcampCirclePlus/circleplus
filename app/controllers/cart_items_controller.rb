class CartItemsController < ApplicationController
  def index
    if user_signed_in?
  	@cart_items = current_user.cart_items
  	@sum = 0
  	@cart_items.each do |cart_item|
  		@price = cart_item.item.item_price_tax_free * cart_item.item_cart_counted
  		@sum += @price
      if cart_item.item_cart_counted > cart_item.item.stock && cart_item.item.stock != 0
        sum = cart_item.item.stock
        cart_item.update(item_cart_counted: sum)
        flash.now[:countupdate] = '在庫数量との関係により、カート内商品個数を修正しました。'
      elsif cart_item.item.item_show_flg == false
        cart_item.destroy
        flash[:cartitemdestroy] = "取り扱いが停止された商品をカートから削除しました。"
        redirect_to cart_path
      elsif cart_item.item.stock == 0
        cart_item.destroy
        flash[:counteddestroy] = "在庫数が0の商品をカートから削除しました。"
        redirect_to cart_path
      end
    end
    else
      redirect_to top_path
    end
  end

  def create
    item = Item.find(params[:item_id])
    user = current_user
    cart_items = current_user.cart_items.where(item_id: item.id)
    if cart_items.count >= 1
      cart_item = CartItem.find_by(item_id: item.id,user_id: user.id)
      cart_item.update(cart_item_params)
      redirect_to cart_path
    else
      cart_item = CartItem.new(ci_update_params)
      cart_item.user_id = current_user.id
      cart_item.item_id = item.id
      cart_item.save(ci_update_params)
      redirect_to cart_path
    end
  end

  def update
    cart_item = CartItem.find(params[:id])
     current_user.id = cart_item.user_id
     cart_item.update(cart_item_params)
     redirect_to cart_path(current_user)
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to cart_path(current_user)
  end



  private
  def cart_item_params
   params.require(:cart_item).permit(:item_cart_counted)
   end
  def ci_update_params
   params.require(:cart_item).permit(:user_id, :item_id, :item_cart_counted)
  end

end
