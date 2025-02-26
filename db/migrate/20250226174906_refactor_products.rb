class RefactorProducts < ActiveRecord::Migration[8.0]
  def change
    Setting.create(
      name: "Active Currency",
      code: "currency",
      description: "The currency to be used by Stripe at checkout",
      value_type: "string",
      value: "USD",
    ) unless Setting.find_by(code: "currency").present?

    change_table :products do |t|
      t.decimal :price, precision: 10, scale: 2
      t.string :name
      t.string :availability
      t.boolean :track_inventory
    end

    remove_column :products, :commissions_performer_id, :bigint

  end
end
