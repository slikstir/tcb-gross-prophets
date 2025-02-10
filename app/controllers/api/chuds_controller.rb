module Api
  class ChudsController < ApiController
    skip_before_action :verify_authenticity_token
    before_action :verify_webhook, only: :buy

    def buy
      Rails.logger.info "Received Shopify Webhook: #{request.raw_post}"

      order = params[:order] || {}
      customer_email = order[:email]
      chuds_value = calculate_chuds(order[:line_items])

  
      if chuds_value > 0
        @attendee = Attendee.find_or_initialize_by(email: customer_email)

        if @attendee.new_record?
          @attendee.name = "New Attendee"
          @attendee.save
        end

        @attendee.update(chuds_balance: (@attendee.chuds_balance + chuds_value))

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
        metafields = item.dig(:product, :metafields)
        chuds = metafields&.dig('gross-prophets', 'chuds')&.to_i || 0
        chuds * item[:quantity]
      end
    end
  end
end