# == Schema Information
#
# Table name: vouchers
#
#  id         :bigint           not null, primary key
#  amount     :integer
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Voucher < ApplicationRecord
  validates :amount, :code, presence: true
  validates :code, uniqueness: true

  has_many :attendee_vouchers
  has_many :attendees, through: :attendee_vouchers

  before_save :downcase_code

  def already_redeemed_by?(email)
    attendee = Attendee.find_by(email: email)
    return false if attendee.blank?

    attendee_voucher = AttendeeVoucher.find_by(attendee: attendee, voucher: self)
    return false if attendee_voucher.blank?

    return true
  end

  def redeem_for(email)
    attendee = Attendee.find_by(email: email)
    return false if attendee.blank?
    transaction do 
      attendee_voucher = AttendeeVoucher.new(
          attendee: attendee, 
          voucher: self, 
          redeemed_at: Date.today
      )
      attendee_voucher.save
      attendee.update(chuds_balance: attendee.chuds_balance + self.amount)
    end
  end

  private 

  def downcase_code
    self.code = self.code.downcase
  end

end
