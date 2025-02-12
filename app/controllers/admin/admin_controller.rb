module Admin
  class AdminController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :check_if_live

    layout "admin"

    def index
    end
  end
end
