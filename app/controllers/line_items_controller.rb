class LineItemsController < ApplicationController
  before_action :find_or_initialize_order

  def create
    ActiveRecord::Base.transaction do
      @order.save unless @order.persisted?
      @line_item = @order.line_items.build(line_item_params)
      @line_item.save!
      session[:order_id] = @order.id
    end
    
    if @line_item.valid? 
      redirect_to cart_path
    else
      redirect_to 'shop'
    end
  end

  def update
    @line_item = LineItem.find(params[:id])
    if @line_item.update(line_item_params)
      redirect_to cart_path
    else
      redirect_to 'shop'
    end
  end
  
  def destroy
    @line_item = LineItem.find(params[:id])
    if @line_item.destroy
      redirect_to cart_path
    else
      redirect_to 'shop'
    end
  end

  private

  def find_or_initialize_order
    if session[:order_id].present?
      @order = Order.find(session[:order_id])
    else
      @order = Order.new(
        email: session[:email],
        attendee: Attendee.find_by(email: session[:email]),
        currency: @currency.downcase,
        tax_rate: @tax_rate,
        channel: 'in_show'
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
