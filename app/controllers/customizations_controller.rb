class CustomizationsController < ApplicationController
  def styles
    setting = Setting.find_by(code: "custom_css")
    @custom_css = setting&.value || ""

    render body: @custom_css, content_type: "text/css"
  end
end
