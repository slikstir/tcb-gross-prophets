class Attendee < ApplicationRecord
  after_initialize :set_defaults

  validates :name, :email, presence: true

  def set_defaults
    self.chuds = 100 if self.chuds.blank?
  end
end
