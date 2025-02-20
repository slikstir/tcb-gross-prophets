class AttendeesController < ApplicationController
  skip_before_action :check_if_logged_in, only: [:new, :create]

  def new

  end

  def create
    @attendee = Attendee.find_or_initialize_by(email: permitted_params[:email])
    @attendee.name = permitted_params[:name]
    @attendee.seat_number = permitted_params[:seat_number] if permitted_params[:seat_number].present?
    @attendee.save
    
    session[:show_code] = params[:show_code].downcase
    session[:email] = @attendee.email

    redirect_to root_path
  end

  def edit

  end

  def update

  end

  def show
    
  end

  private

  def permitted_params
    params.require(:attendee).permit(:email, :name, :seat_number)
  end
end
