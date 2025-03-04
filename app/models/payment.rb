# == Schema Information
#
# Table name: payments
#
#  id           :bigint           not null, primary key
#  amount       :integer          default(1)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  attendee_id  :bigint           not null
#  performer_id :bigint           not null
#
# Indexes
#
#  index_payments_on_attendee_id   (attendee_id)
#  index_payments_on_performer_id  (performer_id)
#
# Foreign Keys
#
#  fk_rails_...  (attendee_id => attendees.id)
#  fk_rails_...  (performer_id => performers.id)
#
class Payment < ApplicationRecord
  belongs_to :attendee
  belongs_to :performer

  validates :attendee, :performer, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }

  after_create :process_chud_transfer

  def process_chud_transfer
    ActiveRecord::Base.transaction do
      attendee.lock! # Lock the attendee row
      performer.lock! # Lock the performer row

      # DISCOUNT RATE IS CURRENTLY 1.0
      discounted_chuds = amount * 1.0

      # Always fetch fresh values inside the transaction
      new_attendee_balance = attendee.chuds_balance - amount
      new_performance_points = attendee.performance_points + amount
      new_performer_balance = performer.chuds_balance + discounted_chuds

      if new_attendee_balance < 0
        raise ActiveRecord::Rollback, "Not enough chuds!"
      end

      # Apply updates within the transaction
      attendee.update!(chuds_balance: new_attendee_balance, performance_points: new_performance_points)
      performer.update!(chuds_balance: new_performer_balance)
    end
  end
end
