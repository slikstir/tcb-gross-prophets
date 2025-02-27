class AddTaxExemptionToProducts < ActiveRecord::Migration[8.0]
  def change
    change_table :products do |t|
      t.boolean :taxable, default: true
      t.boolean :requires_fulfillment, default: true
    end
  end
end
