# == Schema Information
#
# Table name: attendees
#
#  id                 :bigint           not null, primary key
#  chuds_balance      :integer
#  email              :string
#  level              :integer
#  name               :string
#  performance_points :integer
#  seat_number        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Attendee < ApplicationRecord
  after_initialize :set_defaults

  default_scope { order(:email) }

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :payments, dependent: :destroy
  has_many :votes, dependent: :destroy

  def set_defaults
    self.chuds_balance = 100 if self.chuds_balance.blank?
    self.level = 1 if self.level.blank?
    self.performance_points = 0 if self.performance_points.blank?
  end
end
