class AddStripePaymentIdToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :stripe_payment_id, :string
  end
end
