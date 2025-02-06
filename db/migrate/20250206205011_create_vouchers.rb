class CreateVouchers < ActiveRecord::Migration[8.0]
  def change
    create_table :vouchers do |t|
      t.string :code
      t.integer :amount
      t.timestamps
    end
  end
end
