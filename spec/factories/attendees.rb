FactoryBot.define do
  factory :attendee do
    name { "Attendee" }
    sequence(:email) { |n| "email-#{n}@example.com" }
    chuds_balance { 1000 }
    performance_points { 0 }
  end
end
