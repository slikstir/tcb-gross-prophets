class Store::CheckoutController < ApplicationController
  layout 'store' 
  
  before_action :set_store_dropdowns
  before_action :enable_admin_mode

  skip_before_action :check_if_live
  skip_before_action :check_if_logged_in

  def cart
    @cart = Order.find_by(id: session[:merch_order_id])
    @line_items = @cart.line_items if @cart.present?
  end

  def empty
    @cart = Order.find(params[:order_id])
    @cart.line_items.destroy_all
    redirect_to store_path, notice: "Cart has been emptied."
  end

  def qr
    @order = Order.find(params[:order_id])

    line_items = @order.line_items.map do |item|
      product_data = {
        name: item.product.name
      }

      options = [
        item.product.option_1.presence && "Option 1: #{item.product.option_1}",
        item.product.option_2.presence && "Option 2: #{item.product.option_2}",
        item.product.option_3.presence && "Option 3: #{item.product.option_3}"
      ].compact

      product_data[:description] = options.join(" | ") if options.any?

      {
        price_data: {
          currency: @order.currency,
          unit_amount: ((item.unit_price_with_tax) * 100).to_i,
          product_data: product_data
        },
        quantity: item.quantity
      }
    end

    payment_method_types = ["card"]
    payment_method_types << "afterpay_clearpay" if @order.currency.downcase == "usd"

    session = Stripe::Checkout::Session.create(
      payment_method_types: payment_method_types,
      mode: "payment",
      customer_email: @order.email,
      success_url: store_checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: store_checkout_cancel_url,
      line_items: line_items,
      metadata: {
        order_number: @order.number,
        order_id: @order.id
      }
    )

    @checkout_url = session.url
    @qr = RQRCode::QRCode.new(@checkout_url)
  end


  def create
    order = Order.find(params[:order_id])

    line_items = order.line_items.map do |item|
      product_data = {
        name: item.product.name
      }

      # Collect options only if they exist
      options = [
        item.product.option_1.presence && "Option 1: #{item.product.option_1}",
        item.product.option_2.presence && "Option 2: #{item.product.option_2}",
        item.product.option_3.presence && "Option 3: #{item.product.option_3}"
      ].compact

      # Only include description if options exist
      product_data[:description] = options.join(" | ") if options.any?

      {
        price_data: {
          currency: order.currency,
          unit_amount: ((item.unit_price_with_tax) * 100).to_i,
          product_data: product_data
        },
        quantity: item.quantity
      }
    end

    payment_method_types = ["card"]
    payment_method_types << "afterpay_clearpay" if order.currency.downcase == "usd"

    stripe = Stripe::Checkout::Session.create(
      payment_method_types: payment_method_types,      
      mode: "payment",
      customer_email: order.email,
      success_url: store_checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: store_checkout_cancel_url,
      line_items: line_items,
      metadata: {
        order_number: order.number,
        order_id: order.id
      }
    )

    render json: { url: stripe.url }
  end

  def success
    stripe = Stripe::Checkout::Session.retrieve(params[:session_id])
    order = Order.find_by(number: stripe.metadata["order_number"])
    order.update(
      stripe_payment_id: stripe.payment_intent,
      email: stripe.customer_details.email
    )
    if stripe.payment_status == "paid"
      order.pay
      session[:merch_order_id] = nil
      redirect_to store_order_path(order), notice: "Payment successful! Thank you for your order!"
    else
      redirect_to store_cart_path, alert: "Payment failed."
    end
  rescue Exception => e
    Rails.logger.error "Error processing payment: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    order.cancel_stripe_payment
    redirect_to cart_path, alert: "Payment failed. Let the gurus know you got the error '#{e.message}'."
  end

  def cancel
    redirect_to store_cart_path, alert: "Payment was canceled."
  end

  def new
    session[:merch_order_id] = nil
    redirect_to store_path
  end

  def cash
    order = Order.find(params[:order_id])
    order.pay
    session[:merch_order_id] = nil
    redirect_to store_order_path(order), notice: "Order has been paid for."
  end

  private 

  def enable_admin_mode
    if params[:admin].present? 
      session[:admin_mode] = ( params[:admin] == "true" )
    end
    @admin_mode = session[:admin_mode]
  end
end

