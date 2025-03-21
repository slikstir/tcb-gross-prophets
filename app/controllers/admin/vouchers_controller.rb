module Admin
  class VouchersController < AdminController
    before_action :set_voucher, only: [:show, :edit, :update, :destroy]

    # GET /admin/vouchers
    def index
      @vouchers = Voucher.all
    end

    # GET /admin/vouchers/1
    def show
    end

    # GET /admin/vouchers/new
    def new
      @voucher = Voucher.new
    end

    # GET /admin/vouchers/1/edit
    def edit
    end

    # POST /admin/vouchers
    def create
      @voucher = Voucher.new(voucher_params)

      if @voucher.save
        redirect_to [:admin, @voucher], notice: 'Voucher was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/vouchers/1
    def update
      if @voucher.update(voucher_params)
        redirect_to [:admin, @voucher], notice: 'Voucher was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/vouchers/1
    def destroy
      @voucher.destroy
      redirect_to admin_vouchers_url, notice: 'Voucher was successfully destroyed.'
    end

    def upload
      if request.post?
        csv_file = params[:csv]
        if csv_file.present?
          results = Voucher.upload(csv_file)
          redirect_to admin_vouchers_url, notice: "Vouchers upload processed."\
                                                  "#{results[:success]} vouchers created, #{results[:failure]} failed. "\
                                                  "#{results[:failures].map{|x| "#{x[:code]}: #{x[:error]}"}.join(', ')}"
        else
          redirect_to admin_vouchers_url, notice: 'Please upload a CSV file.'
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_voucher
        @voucher = Voucher.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def voucher_params
        params.require(:voucher).permit(:code, :amount)
      end
  end
end