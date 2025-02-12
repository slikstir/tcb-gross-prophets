class WelcomeController < ApplicationController
  layout :set_layout

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
