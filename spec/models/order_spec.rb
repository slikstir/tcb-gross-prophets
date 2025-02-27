# == Schema Information
#
# Table name: orders
#
#  id                :bigint           not null, primary key
#  channel           :string
#  chuds             :integer
#  currency          :string
#  email             :string
#  fulfilled_at      :datetime
#  fulfillment_state :string
#  number            :string
#  payment_state     :string
#  subtotal          :decimal(10, 2)   default(0.0)
#  tax_rate          :decimal(5, 4)    default(0.0)
#  tax_total         :decimal(10, 2)   default(0.0)
#  total             :decimal(10, 2)   default(0.0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  attendee_id       :bigint
#
# Indexes
#
#  index_orders_on_attendee_id  (attendee_id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
