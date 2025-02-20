class WelcomeController < ApplicationController
  layout :set_layout
  skip_before_action :check_if_logged_in, only: [:login, :sign_out, :closed]

  def index
    @homepage_image = Setting.find_by(code: "homepage_image")
  end

  def sign_out
    session[:email] = nil
    redirect_to root_path
  end

  def closed
    setting = Setting.find_by(code: "system_live")
    if setting.present? && setting.value == "true"
      redirect_to root_path
    end
  end

  private

  def set_layout
    case action_name
    when "closed"
      "minimum"
    else
      "application"
    end
  end
end
