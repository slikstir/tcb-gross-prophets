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

  after_create :deadlock_safe_process_chud_transfer

  def deadlock_safe_process_chud_transfer
    with_deadlock_retry do
      process_chud_transfer
    end
  rescue ActiveRecord::Rollback => e
    Rails.logger.error("Payment processing failed: #{e.message}")
    raise ActiveRecord::Rollback, "Payment processing failed"
  end

  def process_chud_transfer
    ActiveRecord::Base.transaction do
      # Sort both records to lock in consistent order
      locks = [attendee, performer].sort_by(&:id)
      locks.each(&:lock!)
  
      discounted_chuds = amount * 1.0
  
      new_attendee_balance = attendee.chuds_balance - amount
      new_performance_points = attendee.performance_points + amount
      new_performer_balance = performer.chuds_balance + discounted_chuds
  
      raise ActiveRecord::Rollback, "Not enough chuds!" if new_attendee_balance < 0
  
      attendee.update!(
        chuds_balance: new_attendee_balance,
        performance_points: new_performance_points
      )
  
      performer.update!(
        chuds_balance: new_performer_balance
      )
    end
  end

  def with_deadlock_retry(retries = 3)
    yield
  rescue ActiveRecord::Deadlocked => e
    raise if (retries -= 1).zero?
    sleep(rand * 0.05) # tiny delay
    retry
  end
  
end
