class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.integer :amount, default: 1
      t.references :attendee, null: false, foreign_key: true
      t.references :performer, null: false, foreign_key: true
      t.timestamps
    end
  end
end
