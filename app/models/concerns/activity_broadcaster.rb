module ActivityBroadcaster
  extend ActiveSupport::Concern

  included do
    after_update_commit :broadcast_activity
  end

  private

  def broadcast_activity
    return unless self.activities.any?

    Turbo::StreamsChannel.broadcast_prepend_to(
      "timeline",
      target: "timeline",
      partial: "admin/activities/update",
      locals: { object: self, activity: self.activities.last }
    )
  end
end
