class WelcomeController < ApplicationController

  def sign_out
    session[:email] = nil
    redirect_to root_path
  end
end
