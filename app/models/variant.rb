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
class Variant < ApplicationRecord
  belongs_to :product,
      inverse_of: :parent,
      optional: true

  validates :sku, presence: true

  delegate :name, :price, to: :product

  def in_stock?
    return true unless product.track_inventory?
    
    return false if stock_level.nil?
    return true if stock_level > 0
    false
  end

  def options
    {
      product.option_1 => option_1,
        product.option_2 => option_2,
        product.option_3 => option_3
    }.compact.reject { |k, v| v.blank? || k.blank? }
  end
end
