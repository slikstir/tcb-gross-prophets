# == Schema Information
#
# Table name: orders
#
#  id                :bigint           not null, primary key
#  channel           :string
#  chuds             :integer
#  completed_at      :datetime
#  currency          :string
#  email             :string
#  fulfilled_at      :datetime
#  fulfillment_state :string
#  number            :string
#  payment_state     :string
#  subtotal          :decimal(10, 2)   default(0.0)
#  tax_rate          :decimal(5, 4)    default(0.0)
#  tax_total         :decimal(10, 2)   default(0.0)
#  total             :decimal(10, 2)   default(0.0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  attendee_id       :bigint
#  stripe_payment_id :string
#
# Indexes
#
#  index_orders_on_attendee_id   (attendee_id)
#  index_orders_on_completed_at  (completed_at)
#

require 'csv'
include Rails.application.routes.url_helpers

class Order < ApplicationRecord
  paginates_per 100

  CURRENCIES =  %w[
            usd eur gbp jpy cny rmb aud cad chf hkd sgd
            nzd inr brl rub zar krw mxn idr try thb
            ]

  scope :paid, -> { where(payment_state: "paid") }


  belongs_to :attendee, optional: true
  has_many :line_items, dependent: :destroy

  before_create :assign_number
  before_save   :assign_attendee
  before_save   :broadcast_purchase, if: -> { broadcast? }

  validates :currency, presence: true, inclusion: { in: CURRENCIES }
  validates :stripe_payment_id, uniqueness: true, allow_nil: true

  attribute :broadcast, :boolean, default: false

  state_machine :payment_state, initial: :cart do
    state :cart
    state :paid
    state :canceled

    event :pay do
      transition cart: :paid
    end

    event :cancel_payment do
      transition any => :canceled
    end

    before_transition on: :pay, do: :set_completed_at
    after_transition on: :pay, do: :commission_performers
    after_transition on: :pay, do: :give_attendee_chuds
    after_transition on: :pay, do: :deduct_stock
    after_transition on: :pay, do: :automatic_fulfillment
    after_transition on: :pay, do: :broadcast_purchase
  end

  state_machine :fulfillment_state, initial: :pending do
    state :pending
    state :packaged
    state :delivered
    state :canceled

    event :package do
      transition pending: :packaged
    end

    event :deliver do
      transition [ :pending, :packaged ] => :delivered
    end

    event :cancel_fulfillment do
      transition any => :canceled
    end

    before_transition on: :deliver, do: :set_fulfilled_at
  end

  def cancel
    if cancel_stripe_payment == true
      self.cancel_payment
      self.cancel_fulfillment
    end
  end

  def canceled?
    payment_state == "canceled"
  end

  def update_totals
    self.chuds = line_items.sum { |x| x.chuds.to_i * x.quantity }
    self.subtotal = line_items.sum(&:total_price)
    self.tax_total = subtotal * tax_rate
    self.total = subtotal + tax_total
    self.save
  end

  def requires_fulfillment?
    line_items.map(&:requires_fulfillment?).any? { |x| x == true }
  end

  def cancel_stripe_payment
    payment_intent = Stripe::PaymentIntent.retrieve(stripe_payment_id)

    case payment_intent.status
    when "requires_capture"
      intent = Stripe::PaymentIntent.cancel(stripe_payment_id)
      intent.status == "canceled"
    when "succeeded", "processing"
      refund = Stripe::Refund.create({
        payment_intent: stripe_payment_id
      })
      refund.status == "succeeded"
    else
      Rails.logger.info "PaymentIntent status is #{payment_intent.status}, cannot cancel or refund."
      nil
    end
  rescue Stripe::StripeError => e
    errors.add(:base, e.message)
  end

  def self.total_sales(start_time, end_time)
    start_time = Time.zone.now.beginning_of_day if start_time.blank?
    end_time = Time.zone.now.end_of_day if end_time.blank?

    Order.paid.where(completed_at: start_time..end_time).group(:currency).sum(:total)
  end

  def self.total_commissions(start_time, end_time)
    start_time ||= Time.zone.now.beginning_of_day
    end_time ||= Time.zone.now.end_of_day
  
    LineItem.joins(:order)
            .where(orders: { payment_state: 'paid', completed_at: start_time..end_time })
            .group(:performer_id, 'orders.currency') # Group by performer and currency
            .sum(:total) # Sum total sales for each performer-currency pair
  end

  def self.product_sales(start_time, end_time)
    start_time ||= Time.zone.now.beginning_of_day
    end_time ||= Time.zone.now.end_of_day
  
    LineItem.joins(variant: :product) # Join LineItem → Variant → Product
            .joins(:order) # Join LineItem → Order
            .where(orders: { payment_state: 'paid', completed_at: start_time..end_time }) # Filter paid orders in range
            .group('products.name', 'orders.currency') # Group by product name and currency
            .sum(:total) # Sum total sales for each (product, currency) pair
  end

  def self.line_items_csv(start_time, end_time)
    start_time ||= Time.zone.now.beginning_of_day
    end_time ||= Time.zone.now.end_of_day

    line_items = LineItem.joins(:order, variant: :product)
                         .where(orders: { payment_state: 'paid', completed_at: start_time..end_time })

    CSV.generate(headers: true) do |csv|
      csv << ['Line Item ID', 'Order', 'URL', 'Fulfilled At', 'Product', 'Variant SKU', 'Currency', 'Completed At', 'Quantity', 'Total', 'Performer']

      line_items.each do |line_item|
        csv << [
          line_item.id,
          line_item.order.number,
          admin_order_url(line_item.order),
          line_item.order.fulfilled_at,
          line_item.product.name,
          line_item.variant.sku,
          line_item.order.currency,
          line_item.order.completed_at.strftime('%Y-%m-%d %H:%M:%S'),
          line_item.quantity,
          line_item.total_price,
          line_item.performer.try(:name)
        ]
      end
    end
  end

  def self.orders_csv(start_time, end_time)
    start_time ||= Time.zone.now.beginning_of_day
    end_time ||= Time.zone.now.end_of_day

    Order.paid.where(completed_at: start_time..end_time)
  end
  

  private

  def commission_performers
    line_items.each(&:update_performer_commissions)
  rescue Exception => e
    Rails.logger.error "Error giving commissioning performers: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def broadcast_purchase
    line_items.each(&:broadcast_notification)
  rescue Exception => e
    Rails.logger.error "Error broadcasting purchase: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def set_completed_at
    self.completed_at = Time.now
  rescue Exception => e
    Rails.logger.error "Error marking completed at: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def deduct_stock
    line_items.each do |item|
      next unless item.variant.product.track_inventory?

      item.variant.update(stock_level: item.variant.stock_level - item.quantity)
    end
  rescue Exception => e
    Rails.logger.error "Error deducting stock: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def automatic_fulfillment
    return if requires_fulfillment?

    self.deliver
  rescue Exception => e
    Rails.logger.error "Error automatic fulfilling: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end


  def give_attendee_chuds
    return unless attendee.present?

    attendee.chuds_balance += self.chuds.to_i
    attendee.save
  rescue Exception => e
    Rails.logger.error "Error giving attendees chuds performers: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end

  def assign_number
    last_order = Order.order(number: :desc).first
    next_number = last_order&.number&.scan(/\d+/)&.first.to_i + 1
    self.number = "GP##{next_number.to_s.rjust(5, '0')}"
  end

  def set_fulfilled_at
    update_column(:fulfilled_at, Time.current)
  end

  def assign_attendee
    return unless email.present?
    return if attendee.present?

    self.attendee = Attendee.find_by_normalized_email(email)
  end
end
