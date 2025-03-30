class AttendeesController < ApplicationController
  skip_before_action :check_if_logged_in, only: [ :new, :create ]

  def new
  end

  def create
    @attendee = Attendee.find_by_normalized_email(permitted_params[:email])
    @attendee = Attendee.new(email: permitted_params[:email]) if @attendee.blank?
    @attendee.name = permitted_params[:name]
    @attendee.seat_number = permitted_params[:seat_number] if permitted_params[:seat_number].present?
    @attendee.save

    session[:show_code] = params[:show_code].downcase
    session[:email] = @attendee.email
    session[:show_order_id] = nil

    redirect_to root_path(new_login: true)
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
