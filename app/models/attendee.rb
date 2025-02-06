# == Schema Information
#
# Table name: attendees
#
#  id                 :bigint           not null, primary key
#  chuds              :integer
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

  validates :name, :email, presence: true
  validates :email, uniqueness: true
  default_scope { order(:email) }

  def set_defaults
    self.chuds = 100 if self.chuds.blank?
    self.level = 1 if self.level.blank?
    self.performance_points = 0 if self.performance_points.blank?
  end
end
