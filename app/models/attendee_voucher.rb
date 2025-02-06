# == Schema Information
#
# Table name: attendee_vouchers
#
#  id          :bigint           not null, primary key
#  redeemed_at :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  attendee_id :bigint
#  voucher_id  :bigint
#
# Indexes
#
#  index_attendee_vouchers_on_attendee_id  (attendee_id)
#  index_attendee_vouchers_on_voucher_id   (voucher_id)
#
class AttendeeVoucher < ApplicationRecord
  belongs_to :attendee
  belongs_to :voucher
end
