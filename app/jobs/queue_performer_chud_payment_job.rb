class QueuePerformerChudPaymentJob < ApplicationJob
  queue_as :default

  def perform(performer_id, chuds)
    performer = Performer.lock.find(performer_id)
    performer.update!(chuds_balance: performer.chuds_balance + chuds)
  end
end
