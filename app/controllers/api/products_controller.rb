module Api
  class ProductsController < ApiController
    skip_before_action :verify_authenticity_token

    def show
      render json: Product.find(params[:id]), status: :ok
    rescue
      render json: { error: "Product not found" }, status: :not_found
    end

    def update
      product = Product.find(params[:id])
      if product.update(product_params)
        render json: product, status: :ok
      else
        render json: { error: product.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    rescue 
      render json: { error: "Product not found" }, status: :not_found
    end

    private

    def product_params
      params.require(:product).permit(
        :availability
      )
    end
  end
end
