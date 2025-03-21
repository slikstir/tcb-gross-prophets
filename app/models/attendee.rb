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

  before_create    :set_defaults
  before_save      :normalize_email

  default_scope { order(:email) }

  has_many :payments, dependent: :destroy
  has_many :orders, -> { where(payment_state: "paid") }
  has_many :carts, -> { where(payment_state: "cart") }, class_name: "Order"

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  LEVELS = {
    10 => { index: 1, name: "Brand Warrior" },
    30 => { index: 2, name: "Product Pioneer" },
    60 => { index: 3, name: "Senior Product Pioneer" },
    100 => { index: 4, name: "Consultant" },
    150 => { index: 5, name: "Specialist Consultant" },
    250 => { index: 6, name: "Executive Consultant" },
    350 => { index: 7, name: "Specialist" },
    500 => { index: 8, name: "Consultant Specialist" },
    750 => { index: 9, name: "Executive Specialist" },
    2000 => { index: 10, name: "Model Executive Specialist" }
  }

  def self.find_by_normalized_email(email)
    normalized = normalize_gmail(email)
    find_by("LOWER(email) = ?", normalized)
  end

  def self.normalize_gmail(email)
    return email.downcase unless email.match?(/@gmail\.com\z/i)

    local, domain = email.split("@")
    local.gsub!(".", "") # Remove dots in the local part
    "#{local}@#{domain}".downcase
  end

  def self.reset_chuds_balance(amount = 0)
    Attendee.all.update_all(chuds_balance: amount)
    create_and_broadcast_activity(
       "bulk_update", { chuds_balance: amount.to_s }
    )
    broadcast_page_reload
  end

  def self.reset_performance_points(amount = 0)
    Attendee.all.update_all(performance_points: amount)
    create_and_broadcast_activity(
       "bulk_update", { chuds_balance: amount.to_s }
    )
    broadcast_page_reload
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
    broadcast_page_reload
  end

  def level_name
    LEVELS[LEVELS.keys.select { |l| l <= self.performance_points }.max][:name] rescue "Brand Warrior"
  end

  def level_index
    LEVELS[LEVELS.keys.select { |l| l <= self.performance_points }.max][:index] rescue 1
  end

  def level_points
    current_threshold = LEVELS.keys.select { |l| l <= performance_points }.max || 0
    next_threshold = LEVELS.keys.select { |l| l > performance_points }.min || 10
  
    # Ensure the lowest level (0-9 points) starts at 0 correctly
    current_threshold = 0 if performance_points < LEVELS.keys.first
  
    points_at_level = performance_points - current_threshold
    points_needed = next_threshold - current_threshold
  
    { points_at_level: points_at_level, next_level_points: points_needed }
  end
  

  def level_percentage
    (level_points[:points_at_level] * 1.0) / (level_points[:next_level_points] * 1.0) * 100.0
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

  private

  def set_defaults
    default_chuds = Setting.find_by(code: "attendee_starting_chuds")&.value || 0
    self.chuds_balance = default_chuds if self.chuds_balance.blank?
    self.level = 1 if self.level.blank?
    self.performance_points = 0 if self.performance_points.blank?
  end

  def normalize_email
    self.email = self.class.normalize_gmail(email)
  end
end
