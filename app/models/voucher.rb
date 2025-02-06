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

  has_many :attendee_vouchers
  has_many :attendees, through: :attendee_vouchers

end
