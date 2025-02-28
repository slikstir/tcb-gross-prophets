class ApplicationController < ActionController::Base
  before_action :check_if_live
  before_action :check_chud_checkpoint_time
  before_action :check_if_logged_in
  before_action :set_currency
  before_action :set_tax_rate
  before_action :cart_item_count

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  def check_chud_checkpoint_time
    @chud_checkpoint_time = Setting.find_by(code: "chud_checkpoint_time").try(:value) == true
  end

  def check_if_live
    @live = Setting.find_by(code: "system_live").try(:value) == true

    return if request.path == "/closed" || request.path.include?("/admin")

    unless @live
      redirect_to closed_path
    end
  end

  def check_if_logged_in
    @show_code = Setting.find_by(code: "show_code").try(:value).try(:downcase)
    @attendee = Attendee.find_by(email: session[:email])

    if @show_code.blank?
      session[:email] = nil
      redirect_to login_path, notice: "A show code has not been set up. Please contact the event organizer."
    elsif @attendee.blank?
      redirect_to login_path, notice: "Please log in to continue."
    elsif @show_code!= session[:show_code]
      message = "Your show code, #{session[:show_code]}, does not match the event's show code. Please provide an updated show code"
      session[:email] = nil
      session[:show_code] = nil
      redirect_to login_path, notice: message
    end
  end

  def set_currency 
    @currency = Setting.find_by(code: "currency").try(:value)
  end
  
  def set_tax_rate
    @tax_rate = Setting.find_by(code: "tax_rate").try(:value).to_f
  end
  
  def cart_item_count
    @cart_item_count = Order.find_by(id: session[:order_id]).try(:line_items).sum(:quantity) rescue 0
  end
  
end
