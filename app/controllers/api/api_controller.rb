module Api
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json

    def index
      render json: { success: true, message: "Welcome to the Chuds API" }, status: :ok
    end

    private

    def verify_webhook
      secret = ENV['SHOPIFY_WEBHOOK_SECRET'] || Rails.application.credentials.dig(:shopify, :webhook_secret)
      request_body = request.raw_post
      hmac_header = request.headers['X-Shopify-Hmac-SHA256']
      
      if hmac_header.blank?
        Rails.logger.warn "Unauthorized webhook request - Missing HMAC header"
        render json: { success: false, message: 'Unauthorized' }, status: :unauthorized
        return
      end

      calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', secret, request_body))
  
      unless ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, hmac_header)
        Rails.logger.warn "Unauthorized webhook request - Signature mismatch"
        render json: { success: false, message: 'Unauthorized' }, status: :unauthorized
      end  
    end
  end
end

