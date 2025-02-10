module Admin
  class AttendeesController < AdminController
    before_action :set_attendee, only: [:show, :edit, :update, :destroy]

    def index
      @attendees = if params[:search].present?
        Attendee.where("name ILIKE ? OR email ILIKE ?", "%#{params[:search]}%", "%#{params[:search]}%")
      else
        Attendee.all
      end.page(params[:page] ||= 1)   
    end

    def show; end

    def new
      @attendee = Attendee.new
    end

    def create
      @attendee = Attendee.new(attendee_params)
      if @attendee.save
        redirect_to admin_attendees_path, notice: "Attendee was successfully created."
      else
        flash[:error] = @attendee.errors.full_messages.join(", ")
        render :new
      end
    end

    def edit; end

    def update
      if @attendee.update(attendee_params)
        redirect_to admin_attendee_path(@attendee), notice: "Attendee was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @attendee.destroy
      redirect_to admin_attendees_path, notice: "Attendee was successfully deleted."
    end

    private

    def set_attendee
      @attendee = Attendee.find(params[:id])
    end

    def attendee_params
      params.require(:attendee).permit(:name, :email, 
        :chuds_balance, :seat_number, :performance_points, 
        :level
        ) 
    end
  end
end