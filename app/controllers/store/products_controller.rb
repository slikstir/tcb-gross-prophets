class Store::ProductsController < ApplicationController
  layout 'store' 

  before_action :set_store_dropdowns
  skip_before_action :check_if_live
  skip_before_action :check_if_logged_in

  def index
    @store_message = Setting.find_by(code: 'store_message').try(:html)
    @products = Product.merch_table
    
    @products = @products.where(project: params[:project]) if params[:project].present?
    @products = @products.where(category: params[:category]) if params[:category].present?
  end
end
