module Api
  class ChudsController < ApiController
    skip_before_action :verify_authenticity_token
    before_action :verify_webhook, only: :buy

    def buy
      Rails.logger.info "Received Shopify Webhook: #{request.raw_post}"

      # Parse and extract values
      payload = JSON.parse(request.raw_post, symbolize_names: true)
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
