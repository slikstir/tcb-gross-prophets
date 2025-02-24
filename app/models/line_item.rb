# == Schema Information
#
# Table name: line_items
#
#  id                  :bigint           not null, primary key
#  email               :string
#  quantity            :integer
#  sku                 :string
#  unit_price          :decimal(10, 2)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  attendee_id         :bigint
#  performer_id        :bigint
#  product_id          :bigint
#  remote_line_item_id :string
#  remote_order_id     :string
#
# Indexes
#
#  index_line_items_on_attendee_id          (attendee_id)
#  index_line_items_on_email                (email)
#  index_line_items_on_performer_id         (performer_id)
#  index_line_items_on_product_id           (product_id)
#  index_line_items_on_remote_line_item_id  (remote_line_item_id)
#  index_line_items_on_remote_order_id      (remote_order_id)
#  index_line_items_on_sku                  (sku)
#
class LineItem < ApplicationRecord
  belongs_to :performer, optional: true
  belongs_to :product, optional: true
  belongs_to :attendee, optional: true

  after_create :update_performer_commissions
  after_create_commit :broadcast_notification

  def total_price
    unit_price * quantity
  end

  def update_performer_commissions
    return unless performer.present?

    ActiveRecord::Base.transaction do
      performer.lock! # Lock the performer row
      performer.commission_balance = performer.commission_balance + total_price
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
      message = "#{self.attendee.name} purchased #{self.product.sku}"
    else
      message = "#{self.product.sku} was purchased"
    end

    if self.performer.present?
      message = "#{message} from #{self.performer.name}"
    end

    if self.product.try(:chuds).present?
      message = "#{message} and earned €#{self.product.chuds} CHUDs"
    end
  end
end
