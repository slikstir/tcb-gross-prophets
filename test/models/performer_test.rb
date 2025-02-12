# == Schema Information
#
# Table name: performers
#
#  id                 :bigint           not null, primary key
#  active             :boolean          default(TRUE)
#  chuds_balance      :integer          default(100)
#  name               :string
#  performance_points :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_performers_on_active  (active)
#
require "test_helper"

class PerformerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
