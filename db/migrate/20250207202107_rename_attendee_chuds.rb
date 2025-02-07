class RenameAttendeeChuds < ActiveRecord::Migration[8.0]
  def change
    change_table :attendees do |t|
      t.rename :chuds, :chuds_balance
    end
  end
end
