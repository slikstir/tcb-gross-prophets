class CustomizationsController < ApplicationController
  def styles
    setting = Setting.find_by(code: "custom_css")
    @custom_css = setting&.value || ""

    # Set cache headers (optional, helps control browser caching)
    expires_now # Forces cache expiration
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    
    respond_to do |format|
      format.css { render layout: false }
    end
  end
end
