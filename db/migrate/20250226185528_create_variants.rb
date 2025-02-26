class CreateVariants < ActiveRecord::Migration[8.0]
  def change
    create_table :variants do |t|
      t.boolean :parent, index: true
      t.string :option_1
      t.string :option_2
      t.string :option_3
      t.references :product
      t.string :sku
      t.integer :stock_level
      t.timestamps
    end

    change_table :products do |t|
      t.string :option_1
      t.string :option_2
      t.string :option_3
    end

    remove_column :products, :sku, :string
  end
end
