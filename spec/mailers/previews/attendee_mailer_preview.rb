
class AttendeeMailerPreview < ActionMailer::Preview
 def member_email
    attendee = Attendee.first || Attendee.new(name: "Test User", email: "test@example.com")
    AttendeeMailer.member_email(attendee)
 end
end
