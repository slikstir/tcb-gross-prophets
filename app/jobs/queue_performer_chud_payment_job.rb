class QueuePerformerChudPaymentJob < ApplicationJob
  queue_as :default

  def perform(performer_id, chuds)
    Performer.transaction do
      performer = Performer.lock.find(performer_id)
      performer.update!(chuds_balance: performer.chuds_balance + chuds)
    end
  end
end
