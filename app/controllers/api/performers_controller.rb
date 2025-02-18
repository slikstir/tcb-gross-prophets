module Api
  class PerformersController < ApiController
    skip_before_action :verify_authenticity_token

    def reset_chuds_balance
      amount = params[:amount].to_i || 0
      Performer.reset_chuds_balance(amount)
      render json: { success: true, message: "Performers Chuds balance was successfully reset to #{amount}." }, status: :ok
    end

    def reset_performance_points
      amount = params[:amount].to_i  || 0
      Performer.reset_performance_points(amount)
      render json: { success: true, message: "Performers Performance points were successfully reset to #{amount}" }, status: :ok
    end

    def gift_chuds
      amount = params[:amount].to_i  || 0
      Performer.gift_chuds(amount)
      render json: { success: true, message: "Performers have all been gifted #{amount}" }, status: :ok
    end
  end
end
