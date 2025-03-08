# == Schema Information
#
# Table name: orders
#
#  id                :bigint           not null, primary key
#  channel           :string
#  chuds             :integer
#  completed_at      :datetime
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
#  stripe_payment_id :string
#
# Indexes
#
#  index_orders_on_attendee_id   (attendee_id)
#  index_orders_on_completed_at  (completed_at)
#
FactoryBot.define do
  factory :order do
    
  end
end
