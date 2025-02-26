# == Schema Information
#
# Table name: variants
#
#  id          :bigint           not null, primary key
#  option_1    :string
#  option_2    :string
#  option_3    :string
#  parent      :boolean
#  sku         :string
#  stock_level :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  product_id  :bigint
#
# Indexes
#
#  index_variants_on_parent      (parent)
#  index_variants_on_product_id  (product_id)
#
require 'rails_helper'

RSpec.describe Variant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
