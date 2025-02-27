module Admin::SettingsHelper
  def render_setting_field(setting, form)
    case setting.value_type
    when "string"
      form.text_field :value, class: "form-control"
    when "text"
      form.text_area :value, class: "form-control", rows: 50
    when "integer"
      form.number_field :value, class: "form-control"
    when "decimal"
      form.number_field :value, class: "form-control", step: 0.0001
    when "image"
      form.file_field :image, class: "form-control"
    when "boolean"
      form.select :value, [ [ "Yes", "true" ], [ "No", "false" ] ], { hide_label: true }, class: "form-control"
    when 'html'
      form.rich_text_area :html
    end
  end

  def present_activity_values(setting, value)
    case setting.value_type
    when "boolean"
      value == true ? "Yes" : "No"
    else
      value
    end
  end
end
