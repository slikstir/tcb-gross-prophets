class Store::OrdersController < ApplicationController
  layout 'store' 
  
  before_action :set_store_dropdowns
  skip_before_action :check_if_live
  skip_before_action :check_if_logged_in

  def show
    @order = Order.find(params[:id])
  end
end

