module Admin::OrdersHelper
  def fulfillment_badge_class(state)
    case state
    when "pending" then "secondary"
    when "packaged" then "info"
    when "delivered" then "success"
    when "canceled" then "danger"
    else "dark"
    end
  end

  def payment_badge_class(state)
    case state
    when "paid" then "success"
    when "canceled" then "danger"
    when "cart" then "info"
    else "danger"
    end
  end
end
