class AddSortOrderToProducts < ActiveRecord::Migration[8.0]
  def change
    change_table :products do |t|
      t.integer :sort_order, default: 0, index: true
    end
  end
end
