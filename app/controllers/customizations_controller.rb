class CustomizationsController < ApplicationController
  def styles
    setting = Setting.find_by(code: "custom_css")
    @custom_css = setting&.value || ""

    # Explicitly set Content-Type to CSS
    response.headers["Content-Type"] = "text/css; charset=utf-8"

    # Prevent aggressive caching on iOS Safari
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"

    respond_to do |format|
      format.css { render layout: false }
    end
  end
end
