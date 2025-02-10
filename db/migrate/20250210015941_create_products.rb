class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :sku
      t.integer :chuds
      t.timestamps
    end
  end
end
