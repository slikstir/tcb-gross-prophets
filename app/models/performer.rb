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
class Performer < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :payments, dependent: :destroy

  default_scope { order(:name) }

  scope :active, -> { where(active: true) }

  def self.max_chuds_balance
    self.active.maximum(:chuds_balance)
  end
end
