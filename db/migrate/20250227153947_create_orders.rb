class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string     :number
      t.string     :email
      t.references :attendee
      t.string     :payment_state
      t.string     :fulfillment_state
      t.string     :channel
      t.string     :currency
      t.decimal    :subtotal, precision: 10, scale: 2, default: 0.0
      t.decimal    :tax_rate, precision: 5, scale: 4, default: 0.0
      t.decimal    :tax_total, precision: 10, scale: 2, default: 0.0
      t.decimal    :total, precision: 10, scale: 2, default: 0.0
      t.integer    :chuds
      t.datetime   :fulfilled_at
      t.timestamps
    end

    Setting.create(
      name: "Tax Rate",
      code: "tax_rate",
      description: "Current tax rate for the performance",
      value_type: "decimal",
      value: "",
    ) unless Setting.find_by(code: "tax_rate").present?
  end
end
