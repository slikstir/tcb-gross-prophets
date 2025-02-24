# == Schema Information
#
# Table name: line_items
#
#  id           :bigint           not null, primary key
#  email        :string
#  quantity     :integer
#  sku          :string
#  unit_price   :decimal(10, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  attendee_id  :bigint
#  order_id     :string
#  performer_id :bigint
#  product_id   :bigint
#
# Indexes
#
#  index_line_items_on_attendee_id   (attendee_id)
#  index_line_items_on_email         (email)
#  index_line_items_on_order_id      (order_id)
#  index_line_items_on_performer_id  (performer_id)
#  index_line_items_on_product_id    (product_id)
#  index_line_items_on_sku           (sku)
#
class LineItem < ApplicationRecord
  belongs_to :performer, optional: true
  belongs_to :product, optional: true

  def total_price
    unit_price * quantity
  end
end
