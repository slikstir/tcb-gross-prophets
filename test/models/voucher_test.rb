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
require "test_helper"

class VoucherTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
