class RefactorLineItems < ActiveRecord::Migration[8.0]
  def change
    change_table :line_items do |t|
      t.references :variant, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
    end

    remove_column :line_items, :email, :string
    remove_column :line_items, :attendee_id, :bigint
    remove_column :line_items, :remote_order_id, :string
    remove_column :line_items, :remote_line_item_id, :string
  end
end
