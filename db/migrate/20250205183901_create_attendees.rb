class CreateAttendees < ActiveRecord::Migration[8.0]
  def change
    create_table :attendees do |t|
      t.string :email
      t.string :name
      t.integer :chuds
      t.string :seat_number
      t.integer :performance_points
      t.integer :level
      t.timestamps
    end
  end
end
