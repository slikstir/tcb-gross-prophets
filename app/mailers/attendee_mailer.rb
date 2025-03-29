class AttendeeMailer < ApplicationMailer
    
  def member_email(attendee)
    @attendee = attendee

    mail(
      to: @attendee.email,
      subject: "Your Membership Card for The Company™"
    )
  end
end
