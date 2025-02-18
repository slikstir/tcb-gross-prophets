module Admin
  class PerformersController < AdminController
    before_action :set_performer, only: [ :show, :edit, :update, :destroy ]

    # GET /admin/performers
    def index
      @performers = Performer.all
    end

    # GET /admin/performers/1
    def show
    end

    # GET /admin/performers/new
    def new
      @performer = Performer.new
    end

    # GET /admin/performers/1/edit
    def edit
    end

    # POST /admin/performers
    def create
      @performer = Performer.new(performer_params)

      if @performer.save
        redirect_to [ :admin, @performer ], notice: "Performer was successfully created."
      else
        render :new
      end
    end

    # PATCH/PUT /admin/performers/1
    def update
      if @performer.update(performer_params)
        redirect_to [ :admin, @performer ], notice: "Performer was successfully updated."
      else
        render :edit
      end
    end

    # DELETE /admin/performers/1
    def destroy
      @performer.destroy
      redirect_to admin_performers_url, notice: "Performer was successfully destroyed."
    end

    def reset_chuds_balance
      amount = params[:amount].to_i || 0
      Performer.reset_chuds_balance(amount)
      redirect_to admin_performers_url, notice: "Performers Chuds balance were successfully reset to #{amount}."
    end

    def reset_performance_points
      amount = params[:amount].to_i  || 0
      Performer.reset_performance_points(amount)
      redirect_to admin_performers_url, notice: "Performers Performance points were successfully reset to #{amount}"
    end

    def gift_chuds
      amount = params[:amount].to_i  || 0
      Performer.gift_chuds(amount)
      redirect_to admin_performers_url, notice: "Performers have all been gifted #{amount}"
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_performer
        @performer = Performer.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def performer_params
        params.require(:performer).permit(:name, :performance_points, :chuds_balance, :active, :photo)
      end
  end
end
