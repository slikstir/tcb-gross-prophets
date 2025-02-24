# == Schema Information
#
# Table name: line_items
#
#  id                  :bigint           not null, primary key
#  email               :string
#  quantity            :integer
#  sku                 :string
#  unit_price          :decimal(10, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  attendee_id         :bigint
#  performer_id        :bigint
#  product_id          :bigint
#  remote_line_item_id :string
#  remote_order_id     :string
#
# Indexes
#
#  index_line_items_on_attendee_id          (attendee_id)
#  index_line_items_on_email                (email)
#  index_line_items_on_performer_id         (performer_id)
#  index_line_items_on_product_id           (product_id)
#  index_line_items_on_remote_line_item_id  (remote_line_item_id)
#  index_line_items_on_remote_order_id      (remote_order_id)
#  index_line_items_on_sku                  (sku)
#
require 'rails_helper'

RSpec.describe LineItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
