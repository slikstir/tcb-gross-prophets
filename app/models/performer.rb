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

  tracked only: [:update],
          params: {
            :chuds_balance => proc {|controller, model_instance| ( model_instance.saved_change_to_chuds_balance? ? model_instance.saved_change_to_chuds_balance : nil ) },
            :performance_points => proc {|controller, model_instance| ( model_instance.saved_change_to_performance_points? ? model_instance.saved_change_to_performance_points : nil ) }
          }

  has_many :votes, dependent: :destroy
  has_many :payments, dependent: :destroy

  has_one_attached :photo

  default_scope { order(:name) }

  scope :active, -> { where(active: true) }

  def self.max_chuds_balance
    self.active.maximum(:chuds_balance)
  end

  def self.reset_chuds_balance(amount = 0)
    Performer.all.update_all(chuds_balance: amount)
  end

  def self.reset_performance_points(amount = 0)
    Performer.all.update_all(performance_points: amount)
  end

  def self.gift_chuds(amount = 0)
    Performer.all.each do |performer|
      performer.chuds_balance += amount
      performer.save
    end
  end
end
