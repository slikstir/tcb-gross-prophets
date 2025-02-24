class CreateLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :line_items do |t|
      t.string :order_id, index: true
      t.string :email, index: true
      t.references :attendee
      t.string :sku, index: true
      t.references :performer
      t.references :product
      t.decimal :unit_price, precision: 10, scale: 2
      t.integer :quantity
      t.timestamps
    end
  end
end
