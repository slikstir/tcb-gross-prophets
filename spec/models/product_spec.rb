# == Schema Information
#
# Table name: products
#
#  id                   :bigint           not null, primary key
#  availability         :string
#  category             :string
#  chuds                :integer
#  name                 :string
#  option_1             :string
#  option_2             :string
#  option_3             :string
#  price                :decimal(10, 2)
#  project              :string
#  requires_fulfillment :boolean          default(TRUE)
#  sort_order           :integer          default(0)
#  taxable              :boolean          default(TRUE)
#  track_inventory      :boolean
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_products_on_category    (category)
#  index_products_on_project     (project)
#  index_products_on_sort_order  (sort_order)
#
require 'rails_helper'

RSpec.describe Product, type: :model do
end
