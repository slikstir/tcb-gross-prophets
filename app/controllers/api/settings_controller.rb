module Api
  class SettingsController < ApiController
    skip_before_action :verify_authenticity_token

    def show
      if (setting = Setting.find_by(code: params[:id])).present?
        render json: setting, status: :ok
      else
        render json: { error: "Setting not found" }, status: :not_found
      end
    end

    def update
      setting = Setting.find_by(code: params[:id])
      if setting.update(setting_params)
        render json: setting, status: :ok
      else
        render json: { error: setting.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end

    private

    def setting_params
      params.require(:setting).permit(
        :value
      )
    end
  end
end
