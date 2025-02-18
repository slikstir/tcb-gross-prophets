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
  paginates_per 100

  after_initialize :set_defaults

  default_scope { order(:email) }

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :payments, dependent: :destroy
  has_many :votes, dependent: :destroy

  LEVELS =
  {
    20 => { index: 1, name: "Brand Warrior" },
    40 => { index: 2, name: "Product Pioneer" },
    80 => { index: 3, name: "Senior Product Pioneer" },
    120 => { index: 4, name: "Consultant" },
    150 => { index: 5, name: "Specialist Consultant" },
    180 => { index: 6, name: "Executive Consultant" },
    200 => { index: 7, name: "Specialist" },
    220 => { index: 8, name: "Consultant Specialist" },
    250 => { index: 9, name: "Executive Specialist" },
    300 => { index: 10, name: "Model Executive Specialist" }
  }

  def self.reset_chuds_balance(amount = 0)
    Attendee.all.update_all(chuds_balance: amount)
  end

  def self.reset_performance_points(amount = 0)
    Attendee.all.update_all(performance_points: amount)
  end

  def self.gift_chuds(amount = 0)
    Attendee.all.each do |attendee|
      attendee.chuds_balance += amount
      attendee.save
    end
  end

  def set_defaults
    self.chuds_balance = 100 if self.chuds_balance.blank?
    self.level = 1 if self.level.blank?
    self.performance_points = 0 if self.performance_points.blank?
  end

  def level_name
    LEVELS[LEVELS.keys.select { |l| l <= self.performance_points }.max][:name] rescue "Brand Warrior"
  end

  def level_index
    LEVELS[LEVELS.keys.select { |l| l <= self.performance_points }.max][:index] rescue 1
  end
end
