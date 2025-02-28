# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


Setting.create(
  name: 'System Live',
  code: 'system_live',
  description: 'Is the system live?',
  value_type: 'boolean',
  value: 'true'
) unless Setting.find_by(code: 'system_live').present?

Setting.create(
  name: 'Chud Checkpoint Time?',
  code: 'chud_checkpoint_time',
  description: 'Can attendees spend their chuds on peformers?',
  value_type: 'boolean',
  value: 'false'
) unless Setting.find_by(code: 'chud_checkpoint_time').present?

Setting.create(
  name: 'Attendee Starting Chuds',
  code: 'attendee_starting_chuds',
  description: 'How many chuds do attendees start with?',
  value_type: 'integer',
  value: '0'
) unless Setting.find_by(code: 'attendee_starting_chuds').present?

Setting.create(
  name: 'Performer Starting Chuds',
  code: 'performer_starting_chuds',
  description: 'How many chuds do performers start with?',
  value_type: 'integer',
  value: '0'
) unless Setting.find_by(code: 'performer_starting_chuds').present?

Setting.create(
  name: 'Performer Starting Performance Points',
  code: 'performer_starting_performance_points',
  description: 'How many performance points do performers start with?',
  value_type: 'integer',
  value: '0'
) unless Setting.find_by(code: 'performer_starting_performance_points').present?

Setting.create(
  name: 'Homepage Image',
  code: 'homepage_image',
  description: 'The image displayed on the homepage when a user logs in',
  value_type: 'image'
) unless Setting.find_by(code: 'homepage_image').present?

Setting.create(
  name: 'Homepage Text',
  code: 'homepage_text',
  description: 'The text displayed on the homepage when a user logs in',
  value_type: 'text'
) unless Setting.find_by(code: 'homepage_text').present?

Setting.create(
  name: 'Performance Code',
  code: 'show_code',
  description: 'A unique code for the show required to log into the site as an attendee',
  value_type: 'text',
  value: 'DEFAULT'
) unless Setting.find_by(code: 'show_code').present?

Setting.create(
  name: 'Max Performers Chuds',
  code: 'max_performers_chuds',
  description: 'The maximum number of chuds on the performer status bar',
  value_type: 'integer',
  value: '300'
) unless Setting.find_by(code: 'max_performers_chuds').present?

Setting.create(
  name: "Analytics code",
  code: "analytics_code",
  description: "The Google Analytics code (or other snippets) to track site traffic embedded immediately after the header. ",
  value_type: "text",
  value: "",
) unless Setting.find_by(code: "analytics_code").present?

Setting.create(
  name: "Shop code",
  code: "shop",
  description: "The Shopify buy button code to embed on the shop page.",
  value_type: "text",
  value: "",
) unless Setting.find_by(code: "shop").present?

Setting.create(
  name: "Terms of Service",
  code: "terms",
  description: "The Terms of Service Page",
  value_type: "html",
  value: "",
) unless Setting.find_by(code: "terms").present?

Setting.create(
  name: "Frequently Asked Questions",
  code: "faq",
  description: "The FAQ Page",
  value_type: "html",
  value: "",
) unless Setting.find_by(code: "faq").present?

Setting.create(
  name: "About the Company",
  code: "company",
  description: "The Company Page",
  value_type: "html",
  value: "",
) unless Setting.find_by(code: "company").present?

Setting.create(
  name: "Active Currency",
  code: "currency",
  description: "The currency to be used by Stripe at checkout",
  value_type: "string",
  value: "USD",
) unless Setting.find_by(code: "currency").present?

Setting.create(
  name: "Tax Rate",
  code: "tax_rate",
  description: "Current tax rate for the performance",
  value_type: "decimal",
  value: "",
) unless Setting.find_by(code: "tax_rate").present?