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
  before_save      :normalize_email

  default_scope { order(:email) }

  validates :name, :email, presence: true
  validates :email, uniqueness: true

  has_many :payments, dependent: :destroy
  has_many :votes, dependent: :destroy

  LEVELS =
  {
    12 => { index: 1, name: "Brand Warrior" },
    24 => { index: 2, name: "Product Pioneer" },
    36 => { index: 3, name: "Senior Product Pioneer" },
    48 => { index: 4, name: "Consultant" },
    60 => { index: 5, name: "Specialist Consultant" },
    72 => { index: 6, name: "Executive Consultant" },
    84 => { index: 7, name: "Specialist" },
    96 => { index: 8, name: "Consultant Specialist" },
    108 => { index: 9, name: "Executive Specialist" },
    120 => { index: 10, name: "Model Executive Specialist" }
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
    self.chuds_balance = 0 if self.chuds_balance.blank?
    self.level = 1 if self.level.blank?
    self.performance_points = 0 if self.performance_points.blank?
  end

  def normalize_email
    self.email = self.class.normalize_gmail(email)
  end
end
