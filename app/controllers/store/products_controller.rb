class Store::ProductsController < ApplicationController
  layout 'store' 
  
  skip_before_action :check_if_live
  skip_before_action :check_if_logged_in

  def index
    @products = Product.merch_table
  end
end
