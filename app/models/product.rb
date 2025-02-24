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
class Product < ApplicationRecord
  belongs_to :commissions_performer, 
          class_name: 'Performer', optional: true
end
