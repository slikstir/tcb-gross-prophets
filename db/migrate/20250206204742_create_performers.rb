class CreatePerformers < ActiveRecord::Migration[8.0]
  def change
    create_table :performers do |t|
      t.string :name
      t.integer :performance_points
      t.timestamps
    end
  end
end
