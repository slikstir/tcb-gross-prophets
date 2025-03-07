class VouchersController < ApplicationController
  def index
    if params[:code].present?
      code = params[:code].downcase
      @voucher = Voucher.find_by(code: code)
      if @voucher.blank?
        flash[:alert] = "Voucher not found!"
        redirect_to vouchers_path
      elsif @voucher.already_redeemed?(session[:email])
        flash[:alert] = "This voucher has already been redeemed."
        redirect_to vouchers_path
      else
        @voucher.redeem_for(session[:email])
        flash[:notice] = "Voucher redeemed! ¢#{@voucher.amount} chuds have been added to your account."
        redirect_to root_path
      end
    end
  end
end
