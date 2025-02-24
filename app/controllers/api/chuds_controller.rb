module Api
  class ChudsController < ApiController
    skip_before_action :verify_authenticity_token
    before_action :verify_webhook, only: :buy

    def buy
      Rails.logger.info "Received Shopify Webhook: #{request.raw_post}"

      # Parse and extract values
      payload = JSON.parse(request.raw_post, symbolize_names: true)
      order_id = payload[:id]
      line_items = payload[:line_items] || []
      customer_email = payload[:email]
      billing_first_name = payload.dig(:billing_address, :first_name).presence || "New Attendee"
      chuds_value = calculate_chuds(line_items)

      if chuds_value > 0
        @attendee = Attendee.find_or_initialize_by(email: customer_email)

        if @attendee.new_record?
          @attendee.name = billing_first_name
          @attendee.save
        end

        @attendee.update(chuds_balance: @attendee.chuds_balance.to_i + chuds_value)

        # Now make line items and update the salesperson commissions
        line_items.each do |item|
          product = Product.find_by(sku: item[:sku])
          performer = product&.commissions_performer

          line_item = LineItem.find_or_create_by(
            remote_order_id: order_id,
            remote_line_item_id: item[:id],
            sku: item[:sku],
            quantity: item[:quantity],
            unit_price: item[:price].to_f,
            email: customer_email,
            attendee: @attendee,
            performer: performer,
            product: product
          )
        end

        message = "#{@attendee.email} was allocated #{chuds_value} new chuds"
        Rails.logger.info message
        render json: { success: true, message: message }, status: :ok
      else
        render json: { success: true, message: "No valid chuds in order" }, status: :ok
      end
    end

    private

    def calculate_chuds(line_items)
      line_items.sum do |item|
        product = Product.find_by(sku: item[:sku])
        product ? (product.chuds * item[:quantity].to_i) : 0
      end
    end
  end
end
