# == Schema Information
#
# Table name: vouchers
#
#  id         :bigint           not null, primary key
#  amount     :integer
#  code       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Voucher < ApplicationRecord
  validates :amount, :code, presence: true
  validates :code, uniqueness: true

  has_many :attendee_vouchers
  has_many :attendees, through: :attendee_vouchers

  before_save :downcase_code

  def already_redeemed_by?(email)
    attendee = Attendee.find_by(email: email)
    return false if attendee.blank?

    attendee_voucher = AttendeeVoucher.find_by(attendee: attendee, voucher: self)
    return false if attendee_voucher.blank?

    true
  end

  def already_redeemed?(email)
    AttendeeVoucher.exists?(voucher: self)
  end

  def redeem_for(email)
    attendee = Attendee.find_by(email: email)
    return false if attendee.blank?
    transaction do
      attendee_voucher = AttendeeVoucher.new(
          attendee: attendee,
          voucher: self,
          redeemed_at: Date.today
      )
      attendee_voucher.save
      attendee.update(chuds_balance: attendee.chuds_balance + self.amount)
    end
  end

  def path
    Rails.application.routes.url_helpers.vouchers_path(
      code: code
    )
  end

  def url
    Rails.application.routes.url_helpers.url_for(
      controller: "vouchers",
      action: "index",
      code: code
    )
  end

  def qr_svg
    qr = RQRCode::QRCode.new(url)
    svg = qr.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 4,
      standalone: true,
      use_path: true
    )
  end

  def qr_png
    qr = RQRCode::QRCode.new(url)
    png = qr.as_png(
      bit_depth: 1,
      border_modules: 0,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 6,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 400
    )

    Base64.strict_encode64(png.to_s)
  end

  private

  def downcase_code
    self.code = self.code.downcase
  end
end
