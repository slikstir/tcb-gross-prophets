class ApplicationController < ActionController::Base
  before_action :check_if_live
  before_action :check_chud_checkpoint_time
  before_action :check_if_logged_in

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def check_chud_checkpoint_time
    @chud_checkpoint_time = Setting.find_by(code: "chud_checkpoint_time").try(:value) == "true"
  end

  def check_if_live
    @live = Setting.find_by(code: "system_live").try(:value) == "true"

    return if request.path == "/closed" || request.path.include?("/admin")

    unless @live
      redirect_to closed_path
    end
  end

  def check_if_logged_in
    @attendee = Attendee.find_by(email: session[:email])
    if @attendee.blank?
      redirect_to login_path, notice: "Please log in to continue."
    end
  end
end
