module ApplicationHelper
  def a_or_an(word)
    return "" if word.blank?

    word = word.to_s.downcase
    vowels = %w[a e i o u]

    # Special cases where "h" is silent
    silent_h_words = %w[hour honest honor heir]

    if silent_h_words.include?(word) || vowels.include?(word[0])
      "an"
    else
      "a"
    end
  end

  def homepage_url
    ["http://", Rails.application.routes.default_url_options[:host], "/login?code=", @show_code.value].join
  end

  def homepage_qr_code
    qr = RQRCode::QRCode.new(homepage_url)
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
end
