class ApplicationController < ActionController::Base
  before_action :set_attendee
  before_action :check_if_live

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def set_attendee
    @attendee = Attendee.find_by(email: session[:email])
  end

  def check_if_live
    return if request.path == "/closed"
    setting = Setting.find_by(code: "system_live")
    if setting.blank? || setting.value == "false"
      redirect_to closed_path, notice: "Sorry, but the system is currently down for maintenance."
    end
  end
end
