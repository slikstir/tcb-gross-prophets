class AddActiveToPerformers < ActiveRecord::Migration[8.0]
  def change
    change_table :performers do |t|
      t.boolean :active, default: true, index: true
    end
  end
end
