module Api
  class ApiController < ApplicationController
    protect_from_forgery with: :null_session
    respond_to :json
    skip_before_action :check_if_live
    skip_before_action :check_if_logged_in


    before_action :authenticate_with_token!

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
        render json: { success: true, message: "Show status is #{show_setting.value == true ? 'active' : 'inactive' }" }, status: :ok

      else
        render json: { success: false, message: "Invalid checkpoint action" }, status: :bad_request
      end
    end

    def checkpoint
      chud_checkpoint = Setting.find_by(code: "chud_checkpoint_time")

      if params[:start_or_stop].downcase == "start"
        chud_checkpoint.update(value: "true")
        render json: { success: true, message: "Chud Checkpoint has begun" }, status: :ok
      elsif params[:start_or_stop].downcase == "stop"
        chud_checkpoint.update(value: "false")
        render json: { success: true, message: "Chud Checkpoint has ended" }, status: :ok
      elsif params[:start_or_stop].downcase == "status"
        render json: { success: true, message: "Chud Checkpoint is #{chud_checkpoint.value == true ? 'active' : 'inactive' }" }, status: :ok
      else
        render json: { success: false, message: "Invalid checkpoint action" }, status: :bad_request
      end
    end

    private

    def authenticate_with_token!
      token = request.headers['Authorization'].to_s.remove("Token ").strip
      @current_user = User.find_by(api_token: token)

      unless @current_user
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    end

    def broadcast_performer_reload
      Turbo::StreamsChannel.broadcast_replace_to(
        "performer_page_reload",
        target: "performer_page_reload",
        partial: "shared/reload",
        locals: { which: "performer_page_reload" }
      )
    end
  end
end
