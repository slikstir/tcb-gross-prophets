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

  tracked only: [:update],
          params: {
            :value => proc {|controller, model_instance| ( model_instance.saved_change_to_value? ? model_instance.saved_change_to_value: nil ) }          
          }

  has_one_attached :image

  default_scope { order(:name) }

  after_commit :broadcast_chud_checkpoint_time, if: -> { code == 'chud_checkpoint_time' }

  VALUE_TYPES = %w[
    string
    text
    integer
    image
    boolean
  ]

  VALUE_TYPES.each do |vt|
    define_method("#{vt}?") do
      value_type == vt
    end
  end

  private

  def broadcast_chud_checkpoint_time
    Turbo::StreamsChannel.broadcast_replace_to(
      'chud_checkpoint_alert',
      target: 'chud_checkpoint_alert',
      partial: 'shared/chuds_checkpoint_wrapper',
      locals: { checkpoint_time: value == 'true' }
    )
  end

end
