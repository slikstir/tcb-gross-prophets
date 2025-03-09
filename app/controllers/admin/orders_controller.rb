module Admin
  class OrdersController < AdminController
    respond_to :html, :csv

    def index
      @orders = Order.all

      # Search by customer email

      if params[:search].present?
        @orders = @orders.where("customer_email ILIKE ?", "%#{params[:search]}%")
      end

      # Filter by payment_state (default to 'paid')
      if params[:payment_state].present?
        @orders = @orders.where(payment_state: params[:payment_state])
      elsif params[:payment_state] != ""
        @orders = @orders.where(payment_state: "paid")
      end

      # Filter by fulfillment_state
      if params[:fulfillment_state].present?
        @orders = @orders.where(fulfillment_state: params[:fulfillment_state])
      end

      # Sorting 
      @orders = @orders.order(fulfillment_state: :desc, completed_at: :desc)

      # Pagination
      @orders = @orders.page(params[:page] ||= 1)
    end


    def show
      @order = Order.find(params[:id])
    end

    def new
      @order = Order.new
    end

    def create
      @order = Order.new(order_params)
      if @order.save
        redirect_to edit_admin_order_path(@order)
      else
        render :new
      end
    end

    def edit
      @order = Order.find(params[:id])
    end

    def update
      @order = Order.find(params[:id])
      if @order.update(order_params)
        redirect_to admin_orders_path, notice: "Order ##{@order.number} updated"
      else
        render :edit
      end
    end

    def destroy
      @order = Order.find(params[:id])
      @order.cancel
      redirect_to admin_order_path(@order)
    end

    def reports
      time_zone = params[:time_zone] || "UTC"
      start_time = params[:start_datetime].present? ? Time.zone.parse(params[:start_datetime]) : Time.zone.now.beginning_of_day
      end_time = params[:end_datetime].present? ? Time.zone.parse(params[:end_datetime]) : Time.zone.now.end_of_day
    
      # Convert times to the detected time zone
      Time.use_zone(time_zone) do
        start_time = start_time&.in_time_zone(time_zone)
        end_time = end_time&.in_time_zone(time_zone)
      end

      respond_to do |format|
        format.html do 
          @total_sales = Order.total_sales(start_time, end_time)
          @total_commissions = Order.total_commissions(start_time, end_time)
          @total_product_sales = Order.product_sales(start_time, end_time)
        end

        format.csv do 
          csv_data = Order.line_items_csv(start_time, end_time)
          send_data csv_data, filename: "line_items_#{Time.zone.now.strftime('%Y%m%d_%H%M%S')}.csv"
        end
      end
    end
    

    private

    def order_params
      params.require(:order).permit(
        :email, :payment_state, :fulfillment_state,
        :currency, :channel, :tax_rate, :broadcast
      )
    end
  end
end
