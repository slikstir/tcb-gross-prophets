# == Schema Information
#
# Table name: settings
#
#  id          :bigint           not null, primary key
#  code        :string
#  description :text
#  name        :string
#  value       :text
#  value_type  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_settings_on_code  (code)
#
class Setting < ApplicationRecord
  include Turbo::Broadcastable
  include PublicActivity::Model
  include ActivityBroadcaster

  validates :image, content_type: ['image/png', 'image/jpeg', 'image/gif']

  tracked only: [ :update ],
          params: {
            value: proc { |controller, model_instance| (model_instance.saved_change_to_value? ? model_instance.saved_change_to_value: nil) }
          }

  has_one_attached :image
  has_rich_text :html

  default_scope { order(:name) }

  after_commit :broadcast_chud_checkpoint_time, if: -> { code == "chud_checkpoint_time" }
  after_update_commit -> { broadcast_redirect }

  VALUE_TYPES = %w[
    string
    text
    integer
    decimal
    image
    boolean
    html
  ]

  VALUE_TYPES.each do |vt|
    define_method("#{vt}?") do
      value_type == vt
    end
  end

  def value
    case value_type
    when "integer"
      super.to_i
    when "decimal"
      super.to_f
    when "boolean"
      super == "true"
    else
      super
    end
  end

  def image_thumbnail
    image.variant(resize_to_limit: [150, 150]).processed
  end

  def image_medium
    image.variant(resize_to_limit: [500, 500]).processed
  end

  private

  def broadcast_redirect
    if (self.code == "system_live") ||
       (self.code == "show_code" && self.saved_change_to_value?)
       which = "global_redirect"
      Turbo::StreamsChannel.broadcast_replace_to(
        which,
        target: which,
        partial: "shared/redirect",
        locals: { which: which }
      )
    elsif self.code == "chud_checkpoint_time" && self.value == "false"
      which = "redirect_checkpoint_closed"
      Turbo::StreamsChannel.broadcast_replace_to(
        which,
        target: which,
        partial: "shared/redirect",
        locals: { which: which }
      )
    end
  end

  def broadcast_chud_checkpoint_time
    Turbo::StreamsChannel.broadcast_replace_to(
      "chud_checkpoint_alert",
      target: "chud_checkpoint_alert",
      partial: "shared/chuds_checkpoint_wrapper",
      locals: { checkpoint_time: value == true }
    )
  end
end
