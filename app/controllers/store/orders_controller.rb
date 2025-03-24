class Store::OrdersController < ApplicationController
  layout 'store' 
  
  skip_before_action :check_if_live
  skip_before_action :check_if_logged_in

  def show
    @order = Order.find(params[:id])
  end
end

