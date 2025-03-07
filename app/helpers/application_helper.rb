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
    [
      (Rails.env.production? ? "https://" : "http://"),
      Rails.application.routes.default_url_options[:host],
      "/login?code=",
      @show_code.value
    ].join
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

  def currency_icon(currency_code = nil)
    currency_code = currency_code || @currency

    case currency_code.downcase
    when "usd" then "$"   # US Dollar
    when "eur" then "€"   # Euro
    when "gbp" then "£"   # British Pound
    when "jpy" then "¥"   # Japanese Yen
    when "cny", "rmb" then "¥" # Chinese Yuan (Renminbi)
    when "aud" then "A$"  # Australian Dollar
    when "cad" then "C$"  # Canadian Dollar
    when "chf" then "CHF" # Swiss Franc
    when "hkd" then "HK$" # Hong Kong Dollar
    when "sgd" then "S$"  # Singapore Dollar
    when "nzd" then "NZ$" # New Zealand Dollar
    when "inr" then "₹"   # Indian Rupee
    when "brl" then "R$"  # Brazilian Real
    when "rub" then "₽"   # Russian Ruble
    when "zar" then "R"   # South African Rand
    when "krw" then "₩"   # South Korean Won
    when "mxn" then "MX$" # Mexican Peso
    when "idr" then "Rp"  # Indonesian Rupiah
    when "try" then "₺"   # Turkish Lira
    when "thb" then "฿"   # Thai Baht
    else
      currency_code.upcase # Fallback to uppercase currency code
    end
  end

  def admin?
    request.path.start_with?("/admin") rescue false
  end
end
