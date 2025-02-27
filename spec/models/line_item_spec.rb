# == Schema Information
#
# Table name: line_items
#
#  id           :bigint           not null, primary key
#  quantity     :integer
#  sku          :string
#  unit_price   :decimal(10, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_id     :bigint           not null
#  performer_id :bigint
#  product_id   :bigint
#  variant_id   :bigint           not null
#
# Indexes
#
#  index_line_items_on_order_id      (order_id)
#  index_line_items_on_performer_id  (performer_id)
#  index_line_items_on_product_id    (product_id)
#  index_line_items_on_sku           (sku)
#  index_line_items_on_variant_id    (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (variant_id => variants.id)
#
require 'rails_helper'

RSpec.describe LineItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
