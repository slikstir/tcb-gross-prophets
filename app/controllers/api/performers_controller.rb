module Api
  class PerformersController < ApiController
    skip_before_action :verify_authenticity_token

    def index
      performers = Performer.all
      render json: performers, status: :ok
    end

    def show
      begin 
        performer = Performer.find(params[:id])
        render json: performer, status: :ok
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Performer not found" }, status: :not_found
      end
    end
    

    def reset_chuds_balance
      amount = params[:amount].to_i || 0
      if params[:id].blank?
        Performer.reset_chuds_balance(amount)
        render json: { success: true, message: "All Performers Chuds balance was successfully reset to #{amount}." }, status: :ok
      else
        begin
          performer = Performer.find(params[:id])
          performer.update(chuds_balance: amount)
          render json: { success: true, message: "#{performer.name}'s Chuds balance was successfully reset to #{amount}." }, status: :ok
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Performer not found" }, status: :not_found
        end
      end
    end

    def reset_performance_points
      amount = params[:amount].to_i  || 0
      if params[:id].blank?
        Performer.reset_performance_points(amount)
        render json: { success: true, message: "All Performers Performance points were successfully reset to #{amount}" }, status: :ok
      else
        begin
          performer = Performer.find(params[:id])
          performer.update(performance_points: amount)
          render json: { success: true, message: "#{performer.name}'s Performance points were successfully reset to #{amount}" }, status: :ok
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Performer not found" }, status: :not_found
        end
      end
    end

    def gift_chuds
      amount = params[:amount].to_i  || 0
      if params[:id].blank?
        Performer.gift_chuds(amount)
        render json: { success: true, message: "Performers have all been gifted #{amount}" }, status: :ok
      else
        begin 
          performer = Performer.find(params[:id])
          performer.chuds_balance += amount
          performer.save
          render json: { success: true, message: "#{performer.name} has been gifted #{amount} chuds" }, status: :ok
        rescue ActiveRecord::RecordNotFound
          render json: { error: "Performer not found" }, status: :not_found
        end
      end
    end
  end
end
