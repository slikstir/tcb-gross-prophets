module Admin
  class OrdersController < AdminController
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
        redirect_to admin_order_path(@order)
      else
        render :edit
      end
    end

    def destroy
      @order = Order.find(params[:id])
      @order.cancel
      redirect_to admin_order_path(@order)
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
