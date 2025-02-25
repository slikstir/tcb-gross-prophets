class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  protected

  def self.broadcast_page_reload
    Turbo::StreamsChannel.broadcast_replace_to(
      "page_reload",
      target: "page_reload",
      partial: "shared/reload",
      locals: { which: "page_reload" }
    )
  end

  def broadcast_page_reload
    Turbo::StreamsChannel.broadcast_replace_to(
      "page_reload",
      target: "page_reload",
      partial: "shared/reload",
      locals: { which: "page_reload" }
    )
  end
end
