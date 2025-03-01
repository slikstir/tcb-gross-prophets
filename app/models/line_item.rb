# == Schema Information
#
# Table name: line_items
#
#  id           :bigint           not null, primary key
#  quantity     :integer
#  sku          :string
#  unit_price   :decimal(10, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  order_id     :bigint           not null
#  performer_id :bigint
#  product_id   :bigint
#  variant_id   :bigint           not null
#
# Indexes
#
#  index_line_items_on_order_id      (order_id)
#  index_line_items_on_performer_id  (performer_id)
#  index_line_items_on_product_id    (product_id)
#  index_line_items_on_sku           (sku)
#  index_line_items_on_variant_id    (variant_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (variant_id => variants.id)
#
class LineItem < ApplicationRecord
  belongs_to  :order
  belongs_to  :performer, optional: true
  belongs_to  :variant
  has_one     :product, through: :variant
  has_one     :attendee, through: :order

  delegate :options, to: :variant
  delegate :chuds, to: :product

  before_save :set_price
  after_save  :destroy, if: -> { quantity <= 0 }
  after_save  :update_order_totals

  def total_price
    unit_price * quantity
  end

  def unit_price_with_tax
    unit_price * (1 + order.tax_rate.to_f)
  end

  def update_performer_commissions
    return unless performer.present?

    ActiveRecord::Base.transaction do
      performer.lock! # Lock the performer row
      performer.commission_balance = performer.commission_balance + total_price
      performer.chuds_balance = performer.chuds_balance + total_price.to_i
      performer.save
    end
  end

  def broadcast_notification
    Turbo::StreamsChannel.broadcast_append_to(
      "notifications",
      target: "notifications",
      partial: "shared/notification",
      locals: { message: broadcast_message }
    )
  end

  def broadcast_message
    message = ""
    if self.attendee.present?
      message = "#{self.attendee.name} purchased #{self.product.name}"
    else
      message = "#{self.product.name} was purchased"
    end

    if self.performer.present?
      message = "#{message} from #{self.performer.name}"
    end

    if self.product.try(:chuds).present?
      message = "#{message} and earned ¢#{self.product.chuds * self.quantity} CHUDs"
    end
  end

  def requires_fulfillment?
    self.product.requires_fulfillment?
  end

  private

  def set_price
    self.unit_price = self.variant.price
  end

  def update_order_totals
    self.order.update_totals
  end
end
