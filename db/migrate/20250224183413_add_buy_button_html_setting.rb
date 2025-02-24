class AddBuyButtonHtmlSetting < ActiveRecord::Migration[8.0]
  def change
    Setting.create(
      name: "Shop code",
      code: "shop",
      description: "The Shopify buy button code to embed on the shop page.",
      value_type: "text",
      value: "",
    ) unless Setting.find_by(code: "shop").present?
  end
end
