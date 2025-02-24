module Admin
  class ProductsController < AdminController
    before_action :set_product, only: [ :show, :edit, :update, :destroy ]
    before_action :set_performers, only: [ :new, :create, :edit, :update ]

    def index
      @products = Product.all
    end

    def show
    end

    def new
      @product = Product.new
    end

    def edit
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        redirect_to [ :admin, @product ], notice: "Product was successfully created."
      else
        render :new
      end
    end

    def update
      if @product.update(product_params)
        redirect_to [ :admin, @product ], notice: "Product was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_url, notice: "Product was successfully destroyed."
    end

    private
      def set_product
        @product = Product.find(params[:id])
      end

      def set_performers
        @performers = Performer.all
      end

      def product_params
        params.require(:product).permit(:sku, :chuds, :commissions_performer_id)
      end
  end
end
