# == Schema Information
#
# Table name: products
#
#  id              :bigint           not null, primary key
#  availability    :string
#  chuds           :integer
#  name            :string
#  price           :decimal(10, 2)
#  sku             :string
#  track_inventory :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Product < ApplicationRecord 
  AVAILABILITY_OPTIONS = %w[ in_show merch_table ]

  has_one_attached :image
  has_rich_text :description
  
  belongs_to :commissions_performer, 
          class_name: 'Performer', optional: true

  validates :name, :price, :sku, presence: true
  validates :price, numericality: { greater_than: 0 }
  

end
