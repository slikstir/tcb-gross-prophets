class ApplicationController < ActionController::Base
  before_action :set_attendee

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def set_attendee
    @attendee = Attendee.find_by(email: session[:email])

  end
end
