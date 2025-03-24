class AddCategoryAndShowToProducts < ActiveRecord::Migration[8.0]
  def change
    change_table :products do |t|
      t.string :project, index: true
      t.string :category, index: true
    end
  end
end
