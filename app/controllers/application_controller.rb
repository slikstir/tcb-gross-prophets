class ApplicationController < ActionController::Base
  
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_csrf_error
  rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity

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

  def current_attendee
    @current_attendee ||= Attendee.find_by(email: session[:email])
  end

  private

  def handle_csrf_error
    reset_user_session
    flash[:alert] = "Your session has expired. Please try again."
    redirect_to root_path
  end

  def handle_unprocessable_entity(exception)
    log_unprocessable_entity(exception)
    reset_user_session
    flash[:alert] = "Something went wrong. Please try again."
    redirect_to root_path
  end

  def reset_user_session
    reset_session # Clears session to prevent stale data issues
    cookies.delete("_your_app_session") # Ensure cookies are also cleared
  end

  def log_unprocessable_entity(exception)
    Rails.logger.error "⚠️ 422 Error - Unprocessable Entity ⚠️"
    Rails.logger.error "Exception: #{exception.class} - #{exception.message}"
    Rails.logger.error "Backtrace: #{exception.backtrace.first(10).join("\n")}" # Log first 10 lines
    Rails.logger.error "Attendee: #{current_attendee&.id || 'Guest'}"
    Rails.logger.error "Session Data: #{session.to_hash.except('session_id', '_csrf_token')}"
    Rails.logger.error "Request URL: #{request.fullpath}"
    Rails.logger.error "Request Method: #{request.method}"
    Rails.logger.error "Request Params: #{filtered_params}" rescue nil
    Rails.logger.error "User Agent: #{request.user_agent}"
    Rails.logger.error "IP Address: #{request.remote_ip}"
  end
end
