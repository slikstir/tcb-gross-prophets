# == Schema Information
#
# Table name: orders
#
#  id                :bigint           not null, primary key
#  channel           :string
#  chuds             :integer
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
#
# Indexes
#
#  index_orders_on_attendee_id  (attendee_id)
#
class Order < ApplicationRecord
  CURRENCIES =  %w[ 
            usd eur gbp jpy cny rmb aud cad chf hkd sgd 
            nzd inr brl rub zar krw mxn idr try thb
            ]


  belongs_to :attendee, optional: true
  has_many :line_items, dependent: :destroy

  before_create :assign_number
  before_save   :assign_attendee

  validates :currency, presence: true, inclusion: { in: CURRENCIES }

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
      transition [:pending, :packaged] => :delivered
    end

    event :cancel_fulfillment do 
      transition any => :canceled
    end

    before_transition on: :deliver, do: :set_fulfilled_at
  end

  def cancel
    self.cancel_payment
    self.cancel_fulfillment
  end

  def canceled?
    payment_state == "canceled"
  end

  def update_totals
    self.subtotal = line_items.sum(&:total_price)
    self.tax_total = subtotal * tax_rate
    self.total = subtotal + tax_total
    self.save
  end

  private

  def assign_number
    last_order = Order.order(:created_at).last
    next_number = last_order&.number&.scan(/\d+/)&.first.to_i + 1
    self.number = "GP##{next_number.to_s.rjust(5, '0')}"
  end

  def set_fuilfilled_at
    update_column(:fulfilled_at, Time.current)
  end

  def assign_attendee
    return unless email.present?
    return if attendee.present?

    self.attendee = Attendee.find_by_normalized_email(email)
  end
end
