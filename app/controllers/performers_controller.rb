class PerformersController < ApplicationController
  layout :set_layout

  before_action :set_performers
  skip_before_action :check_if_live, only: [ :status ]
  skip_before_action :check_if_logged_in, only: [ :status ]

  def index
    redirect_to root_path
  end

  def pay
    if request.post?
      params[:performer].each do |performer_id, amount|
        next if amount.to_i.zero? || amount.to_i < 0
        performer = Performer.find(performer_id)
        performer.payments.create(amount: amount, attendee: @attendee)
      end
      flash[:notice] = "Thank you for your payment!"
      redirect_to root_path
    end
  end

  def status
    @max_chuds_balance = Performer.max_chuds_balance
  end

  def vote; end

  private

  def set_performers
    @performers = Performer.active
  end

  def set_layout
    case action_name
    when "status"
      "minimum"
    else
      "application"
    end
  end
end
