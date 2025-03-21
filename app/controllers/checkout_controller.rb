class CheckoutController < ApplicationController
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

    stripe = Stripe::Checkout::Session.create(
      payment_method_types: ['card', 'afterpay_clearpay'],      
      mode: "payment",
      customer_email: order.email,
      success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url,
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
    order.update(stripe_payment_id: stripe.payment_intent)
    if stripe.payment_status == "paid"
      order.pay
      session[:order_id] = nil
      redirect_to order_path(order), notice: "Payment successful! Thank you for your order!"
    else
      redirect_to cart_path, alert: "Payment failed."
    end
  rescue Exception => e
    Rails.logger.error "Error processing payment: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    order.cancel_stripe_payment
    redirect_to cart_path, alert: "Payment failed. Let the gurus know you got the error '#{e.message}'."
  end

  def cancel
    redirect_to cart_path, alert: "Payment was canceled."
  end
end
