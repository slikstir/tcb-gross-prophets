class VouchersController < ApplicationController
  def index
    if session[:email].blank?
      flash[:alert] = "You need to sign in before you can redeem a voucher!"
      redirect_to root_path
    else
      if params[:code].present?
        code = params[:code].downcase
        @voucher = Voucher.find_by(code: code)
        if @voucher.blank?
          flash[:alert] = "Voucher not found!"
          redirect_to vouchers_path
        elsif @voucher.already_redeemed_by?(session[:email])
          flash[:alert] = "You've already redeemed this voucher."
          redirect_to vouchers_path
        else
          @voucher.redeem_for(session[:email])
          flash[:notice] = "Voucher redeemed!"
          redirect_to root_path
        end
      end
    end
  end

end