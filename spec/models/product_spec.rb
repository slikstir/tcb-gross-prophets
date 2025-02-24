# == Schema Information
#
# Table name: products
#
#  id                       :bigint           not null, primary key
#  chuds                    :integer
#  sku                      :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  commissions_performer_id :bigint
#
# Indexes
#
#  index_products_on_commissions_performer_id  (commissions_performer_id)
#
# Foreign Keys
#
#  fk_rails_...  (commissions_performer_id => performers.id)
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
