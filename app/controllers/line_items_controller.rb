class LineItemsController < ApplicationController
  before_action :find_or_initialize_order
  skip_before_action :check_if_live
  skip_before_action :check_if_logged_in


  def create
    which = params[:order_channel] == 'merch_table' ? :merch_order_id : :show_order_id
    
    ActiveRecord::Base.transaction do
      @order.save unless @order.persisted?
      @line_item = @order.line_items.build(line_item_params)
      @line_item.save!
      session[which] = @order.id
    end
    
    if @line_item.valid? 
      @cart_redirect = (params[:order_channel] == 'merch_table' ? store_cart_path : cart_path)

      respond_to do |format|
        cart_item_count
        format.turbo_stream
        format.html { redirect_to cart_redirect }
      end
    else
      @cart_redirect = (params[:order_channel] == 'merch_table' ? 'store' : 'shop')
      redirect_to cart_redirect
    end
  end

  def update
    @line_item = LineItem.find(params[:id])
    if @line_item.update(line_item_params)
      cart_redirect = (params[:order_channel] == 'merch_table' ? store_cart_path : cart_path)
      redirect_to cart_redirect
    else
      cart_redirect = (params[:order_channel] == 'merch_table' ? 'store' : 'shop')
      redirect_to cart_redirect
    end
  end
  
  def destroy
    @line_item = LineItem.find(params[:id])
    if @line_item.destroy
      cart_redirect = (params[:order_channel] == 'merch_table' ? store_cart_path : cart_path)
      redirect_to cart_redirect
    else
      cart_redirect = (params[:order_channel] == 'merch_table' ? 'store' : 'shop')
      redirect_to cart_redirect
    end
  end

  private

  def find_or_initialize_order
    which = params[:order_channel] == 'merch_table' ? :merch_order_id : :show_order_id
    
    if session[which].present?
      @order = Order.find(session[which])
      @order.update(currency: @currency.downcase) if(@order.currency != @currency.downcase)
      @order.update(tax_rate: @tax_rate) if(@order.tax_rate != @tax_rate)
    else
      @order = Order.new(
        email: session[:email],
        attendee: Attendee.find_by(email: session[:email]),
        currency: @currency.downcase,
        tax_rate: @tax_rate,
        channel: params[:order_channel]
      )
    end
  end

  def line_item_params
    params.require(:line_item).permit(
      :quantity, :unit_price, 
      :order_id, :performer_id, :variant_id, :_destroy
    )
  end

end
