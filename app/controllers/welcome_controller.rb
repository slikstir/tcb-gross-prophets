class WelcomeController < ApplicationController
  layout :set_layout
  skip_before_action :check_if_logged_in, only: [ :login, :sign_out, :closed, :terms, :faqs, :order_notifications ]

  def index
    @homepage_image = Setting.find_by(code: "homepage_image")
    @homepage_text = Setting.find_by(code: "homepage_text")
  end

  def sign_out
    session[:email] = nil
    session[:order_id] = nil
    redirect_to root_path
  end

  def closed
    setting = Setting.find_by(code: "system_live")
    if setting.present? && setting.value == true
      redirect_to root_path
    end
  end

  def shop
    @products = Product.where(availability: "in_show")
    @performers = Performer.where(active: true)
  end

  def faqs
    @faqs = Setting.find_by(code: "faq")
  end

  def terms
    @terms = Setting.find_by(code: "terms")
  end

  def company
    @company = Setting.find_by(code: "company")
  end

  def cart
    @cart = Order.find_by(id: session[:order_id])
    @line_items = @cart.line_items if @cart.present?
  end

  def login
    @login_help = Setting.find_by(code: "login_info").try(:html)
  end

  def order_notifications
  end

  private

  def set_layout
    case action_name
    when "closed"
    when "order_notifications"
      "minimum"
    else
      "application"
    end
  end
end
