module Api
  class WebhooksController < ApiController
    skip_before_action :verify_authenticity_token

    def stripe
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      event = nil

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, Rails.application.credentials.dig(:stripe, :webhook_secret))
      rescue JSON::ParserError, Stripe::SignatureVerificationError => e
        render json: { error: e.message }, status: 400 and return
      end

      case event.type
      when "checkout.session.completed"
        session = event.data.object
        order = Order.find_by(number: session.metadata["order_number"])
        order.update(payment_state: "paid") if order
      end

      render json: { message: "success" }
    end
  end
end
