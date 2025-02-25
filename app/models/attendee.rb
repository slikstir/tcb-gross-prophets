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
  include PublicActivity::Model

  tracked only: [ :update ],
    params: {
      chuds_balance: proc { |controller, model_instance| (model_instance.saved_change_to_chuds_balance? ? model_instance.saved_change_to_chuds_balance : nil) },
      performance_points: proc { |controller, model_instance| (model_instance.saved_change_to_performance_points? ? model_instance.saved_change_to_performance_points : nil) },
      level: proc { |controller, model_instance| (model_instance.saved_change_to_level? ? model_instance.saved_change_to_level : nil) }
    }

  paginates_per 100

  after_initialize :set_defaults

  default_scope { order(:email) }

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :payments, dependent: :destroy
  has_many :votes, dependent: :destroy

  LEVELS =
  {
    30 => { index: 1, name: "Brand Warrior" },
    60 => { index: 2, name: "Product Pioneer" },
    90 => { index: 3, name: "Senior Product Pioneer" },
    120 => { index: 4, name: "Consultant" },
    150 => { index: 5, name: "Specialist Consultant" },
    180 => { index: 6, name: "Executive Consultant" },
    210 => { index: 7, name: "Specialist" },
    240 => { index: 8, name: "Consultant Specialist" },
    270 => { index: 9, name: "Executive Specialist" },
    300 => { index: 10, name: "Model Executive Specialist" }
  }

  def self.reset_chuds_balance(amount = 0)
    Attendee.all.update_all(chuds_balance: amount)
    create_and_broadcast_activity(
       "bulk_update", { chuds_balance: amount.to_s }
    )
  end

  def self.reset_performance_points(amount = 0)
    Attendee.all.update_all(performance_points: amount)
    create_and_broadcast_activity(
       "bulk_update", { chuds_balance: amount.to_s }
    )
  end

  def self.gift_chuds(amount = 0)
    Attendee.public_activity_off
    Attendee.all.each do |attendee|
      attendee.chuds_balance += amount
      attendee.save
    end
    Attendee.public_activity_on

    create_and_broadcast_activity(
       "gift_chuds", { chuds_balance: amount.to_s }
    )
  end

  def set_defaults
    self.chuds_balance = 0 if self.chuds_balance.blank?
    self.level = 1 if self.level.blank?
    self.performance_points = 0 if self.performance_points.blank?
  end

  def level_name
    LEVELS[LEVELS.keys.select { |l| l <= self.performance_points }.max][:name] rescue "Brand Warrior"
  end

  def level_index
    LEVELS[LEVELS.keys.select { |l| l <= self.performance_points }.max][:index] rescue 1
  end

  def self.create_and_broadcast_activity(action, opts)
    activity = create_activity(action, opts)
    broadcast_activity(action, activity)
  end

  def self.create_activity(action, opts)
    Attendee.first.create_activity(
        action: action,
        parameters: opts
    )
  end

  def self.broadcast_activity(action, activity)
    Turbo::StreamsChannel.broadcast_prepend_to(
      "timeline",
      target: "timeline",
      partial: "public_activity/attendee/#{action}",
      locals: { object: self, activity: activity }
    )
  end
end
