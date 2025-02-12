class AddChudsToPerformers < ActiveRecord::Migration[8.0]
  def change
    change_table :performers do |t|
      t.integer :chuds_balance, default: 100
    end
  end
end
