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

  after_create :update_performance_points
  after_create :update_attendee_balance
  
  def update_attendee_balance
    attendee.update_column(:chuds_balance, attendee.chuds_balance - amount)
  end

  def update_performance_points
    performer.update_column(:performance_points, performer.performance_points + amount)
  end

end
