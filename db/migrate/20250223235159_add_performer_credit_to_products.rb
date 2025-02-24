class AddPerformerCreditToProducts < ActiveRecord::Migration[8.0]
  def change
    change_table :products do |t|
      t.references :commissions_performer, foreign_key: { to_table: :performers }
    end

    change_table :performers do |t| 
      t.decimal :commission_balance, precision: 10, scale: 2, default: 0.0
    end
  end
end
