class AddCompletedAtToOrders < ActiveRecord::Migration[8.0]
  def change
    change_table :orders do |t|
      t.datetime :completed_at, index: true
    end

    Order.paid.each do |order|
      order.update(completed_at: order.fulfilled_at)
      
      if order.completed_at.blank?
        order.update(completed_at: order.created_at)
      end
    end
  end
end
