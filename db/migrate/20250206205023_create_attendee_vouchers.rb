class CreateAttendeeVouchers < ActiveRecord::Migration[8.0]
  def change
    create_table :attendee_vouchers do |t|
      t.references :attendee
      t.references :voucher
      t.date :redeemed_at
      t.timestamps
    end
  end
end
