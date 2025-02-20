module Api
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json
    skip_before_action :check_if_live
    skip_before_action :check_if_logged_in

    def index
      render json: { success: true, message: "Welcome to the Chuds API" }, status: :ok
    end

    def show_code
      show_code = Setting.find_by(code: "show_code")
      if params[:code].blank?
        render json: { success: false, message: "Show code is required" }, status: :bad_request
      else
        show_code.update(value: params[:code])
        render json: { success: true, message: "Show code has been updated to '#{params[:code]}'" }, status: :ok
      end
    end

    def show
      show_setting = Setting.find_by(code: "system_live")

      if params[:start_or_stop].downcase == "start"
        show_setting.update(value: "true")
        render json: { success: true, message: "Show has begun" }, status: :ok
        
      elsif params[:start_or_stop].downcase == "stop"
        show_setting.update(value: "false")
        render json: { success: true, message: "Show has ended" }, status: :ok
        
      elsif params[:start_or_stop].downcase == "status"
        render json: { success: true, message: "Show status is #{show_setting.value == 'true' ? 'active' : 'inactive' }" }, status: :ok
        
      else
        render json: { success: false, message: "Invalid checkpoint action" }, status: :bad_request
      end
    end

    def checkpoint
      chud_checkpoint = Setting.find_by(code: "chud_checkpoint_time")

      if params[:start_or_stop].downcase == "start"
        chud_checkpoint.update(value: "true")
        render json: { success: true, message: "CHUD Checkpoint has begun" }, status: :ok
      elsif params[:start_or_stop].downcase == "stop"
        chud_checkpoint.update(value: "false")
        render json: { success: true, message: "CHUD Checkpoint has ended" }, status: :ok
      elsif params[:start_or_stop].downcase == "status"
        render json: { success: true, message: "CHUD Checkpoint is #{chud_checkpoint.value == 'true' ? 'active' : 'inactive' }" }, status: :ok
      else
        render json: { success: false, message: "Invalid checkpoint action" }, status: :bad_request
      end
    end

    private

    def verify_webhook
      secret = ENV["SHOPIFY_WEBHOOK_SECRET"] || Rails.application.credentials.dig(:shopify, :webhook_secret)
      request_body = request.raw_post
      hmac_header = request.headers["X-Shopify-Hmac-SHA256"]

      if hmac_header.blank?
        Rails.logger.warn "Unauthorized webhook request - Missing HMAC header"
        render json: { success: false, message: "Unauthorized" }, status: :unauthorized
        return
      end

      calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest("sha256", secret, request_body))

      unless ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, hmac_header)
        Rails.logger.warn "Unauthorized webhook request - Signature mismatch"
        render json: { success: false, message: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
