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
class Product < ApplicationRecord
  AVAILABILITY_OPTIONS = %w[ unavailable in_show merch_table  ]

  has_one_attached :image
  
  has_rich_text :description

  default_scope -> { order(:sort_order) }

  scope :in_show, -> { where(availability: "in_show") }
  scope :merch_table, -> { where(availability: "merch_table") }
  scope :unavailable, -> { where(availability: "unavailable") } 

  has_one :parent,
      -> { where(parent: true) },
      class_name: "Variant",
      foreign_key: :product_id,
      dependent: :destroy

  has_many :children,
      -> { where.not(parent: true) },
      class_name: "Variant",
      foreign_key: :product_id,
      dependent: :destroy

  has_many :variants

  validates :name, :price, :sku, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :availability, inclusion: { in: AVAILABILITY_OPTIONS }
  validates :image, content_type: ['image/png', 'image/jpeg', 'image/gif']

  delegate :sku, :stock_level, to: :parent

  after_initialize :build_parent

  accepts_nested_attributes_for :parent
  accepts_nested_attributes_for :children,
    reject_if: :all_blank, allow_destroy: true

  def build_parent(attributes = {})
    return if parent.present?

    super(attributes.merge(parent: true))
  end

  def options_for(number)
    return [] unless number.to_i.between?(1, 3)
    children.pluck("option_#{number}").uniq
  end

  def image_thumbnail
    image.variant(resize_to_limit: [150, 150]).processed
  end

  def image_medium
    image.variant(resize_to_limit: [500, 500]).processed
  end
end
