class OrderMailer < ApplicationMailer
  
  def receipt_email(order)
    @order = order
    @currency = currency_icon(@order.currency)

    mail(
      to: @order.email,
      subject: "Your Tin Can Order #{@order.number} Receipt"
    )
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
end
