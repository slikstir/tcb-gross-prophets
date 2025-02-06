# == Schema Information
#
# Table name: performers
#
#  id                 :bigint           not null, primary key
#  name               :string
#  performance_points :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "test_helper"

class PerformerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
