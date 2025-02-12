module Admin
  class AdminController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :check_if_logged_in
    skip_before_action :check_if_live

    layout "admin"

    def index
      @open_setting = Setting.find_by(code: "system_live")
      @chud_time_setting = Setting.find_by(code: "chud_checkpoint_time")
    end
  end
end
