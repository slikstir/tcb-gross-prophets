class AddGoogleAnalyticsSetting < ActiveRecord::Migration[8.0]
  def change
    Setting.create(
      name: "Analytics code",
      code: "analytics_code",
      description: "The Google Analytics code (or other snippets) to track site traffic embedded immediately after the header. ",
      value_type: "text",
      value: "",
    ) unless Setting.find_by(code: "analytics_code").present?
  end
end
