# == Schema Information
#
# Table name: products
#
#  id                   :bigint           not null, primary key
#  availability         :string
#  chuds                :integer
#  name                 :string
#  option_1             :string
#  option_2             :string
#  option_3             :string
#  price                :decimal(10, 2)
#  requires_fulfillment :boolean          default(TRUE)
#  taxable              :boolean          default(TRUE)
#  track_inventory      :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
