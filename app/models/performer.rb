# == Schema Information
#
# Table name: performers
#
#  id                 :bigint           not null, primary key
#  active             :boolean          default(TRUE)
#  chuds_balance      :integer          default(100)
#  commission_balance :decimal(10, 2)   default(0.0)
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
  include PublicActivity::Model
  include ActivityBroadcaster

  tracked only: [ :update ],
          params: {
            chuds_balance: proc { |controller, model_instance| (model_instance.saved_change_to_chuds_balance? ? model_instance.saved_change_to_chuds_balance : nil) },
            performance_points: proc { |controller, model_instance| (model_instance.saved_change_to_performance_points? ? model_instance.saved_change_to_performance_points : nil) }
          }

  has_many :payments, dependent: :destroy
  has_many :line_items
  has_many :products, through: :line_items

  has_one_attached :photo

  default_scope { order(:name) }

  scope :active, -> { where(active: true) }

  before_save :ensure_values_present
  after_update_commit :broadcast_performer_reload

  def self.max_chuds_balance
    self.active.maximum(:chuds_balance)
  end

  def self.status_bar_max_value
    [ Performer.max_chuds_balance + Performer.max_chuds_balance * 0.20, Setting.find_by(code: "max_performers_chuds").try(:value).to_i ].max
  end

  def self.reset_chuds_balance(amount = 0)
    Performer.all.update_all(chuds_balance: amount)
    create_and_broadcast_activity(
       "bulk_update", { chuds_balance: amount.to_s }
    )
  end

  def self.reset_performance_points(amount = 0)
    Performer.all.update_all(performance_points: amount)
    create_and_broadcast_activity(
       "bulk_update", { chuds_balance: amount.to_s }
    )
  end

  def self.gift_chuds(amount = 0)
    Performer.public_activity_off
    Performer.all.each do |performer|
      performer.chuds_balance += amount
      performer.save
    end
    Performer.public_activity_on

    create_and_broadcast_activity(
       "gift_chuds", { chuds_balance: amount.to_s }
    )
  end

  def self.gift_performance_points(amount = 0)
    Performer.public_activity_off
    Performer.all.each do |performer|
      performer.performance_points += amount
      performer.save
    end
    Performer.public_activity_on

    create_and_broadcast_activity(
       "gift_performance_points", { performance_points: amount.to_s }
    )
  end


  def self.create_and_broadcast_activity(action, opts)
    activity = create_activity(action, opts)
    broadcast_activity(action, activity)
  end

  def self.create_activity(action, opts)
    Performer.first.create_activity(
        action: action,
        parameters: opts
    )
  end

  def self.broadcast_activity(action, activity)
    Turbo::StreamsChannel.broadcast_prepend_to(
      "timeline",
      target: "timeline",
      partial: "public_activity/performer/#{action}",
      locals: { object: self, activity: activity }
    )
  end

  def broadcast_performer_reload
    if self.saved_change_to_chuds_balance? || self.saved_change_to_performance_points?
      Performer.active.each do |performer|
        Turbo::StreamsChannel.broadcast_replace_to(
          "performer_#{performer.id}_status_bar",
          target: "performer_#{performer.id}_status_bar",
          partial: "performers/status_bar",
          locals: { performer: performer, max_chuds_balance: Performer.status_bar_max_value  }
        )
      end
    end
  end

  private

  def ensure_values_present
    self.chuds_balance ||= 0
    self.performance_points ||= 0
    self.commission_balance ||= 0
  end
end
