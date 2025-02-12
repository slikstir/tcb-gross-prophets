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
require 'rails_helper'

RSpec.describe Attendee, type: :model do
  let(:total_transactions) { 200 }
  let(:attendees) { create_list(:attendee, total_transactions, chuds_balance: 100, performance_points: 0) }
  let(:performer) { create(:performer, chuds_balance: 0) }
  let(:amount) { 12 }

  describe "#transact_chuds" do
    it "handles concurrent chud transactions safely" do
      threads = []

      # Create transactions in batches to prevent DB pool exhaustion
      attendees.each_slice(20) do |batch|
        batch.each do |attendee|
          threads << Thread.new do
            ActiveRecord::Base.connection_pool.with_connection do
              Payment.create!(attendee: attendee, performer: performer, amount: amount)
            end
          end
        end
        threads.each(&:join)  # Wait for each batch
      end

      sleep 1  # Allow DB to settle before assertions

      # Ensure each attendee's balance is updated correctly
      attendees.each do |attendee|
        attendee.reload
        expect(attendee.chuds_balance).to eq(100 - amount)
        expect(attendee.performance_points).to eq(amount)
      end

      # Ensure performer's chud balance matches expected value
      expected_performer_chuds = total_transactions * amount * 0.75
      expect(performer.reload.chuds_balance).to eq(expected_performer_chuds)
    end
  end
end
