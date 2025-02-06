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
class Performer < ApplicationRecord
end
