ruby "3.2.6" # Example version, update as needed

source "https://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mswin jruby ]

# Use the database-backed adapters for Rails.cache and Active Job
gem "solid_cache"
gem "solid_queue"

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug"
  gem "pry-byebug"
  gem "byebug"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
  gem "factory_bot_rails", "~> 6.4"
  gem "rspec-rails", "~> 7.1"
end

gem "turbo-rails", "~> 2.0"
gem "stimulus-rails"

gem "importmap-rails", "~> 2.1"

gem "devise", "~> 4.9", ">= 4.9.4"
gem "annotaterb"
gem "bootstrap_form", "~> 5.4"

gem "pagy"
gem "redis", "~> 4.3", ">= 4.3.1"
gem "aws-sdk-s3", require: false

gem "rails_icons", "~> 1.1"
gem "rqrcode"
gem "chunky_png"

gem 'public_activity'

gem "image_processing", "~> 1.14"
gem 'mini_magick', '~> 5.0'
gem 'ruby-vips', '~> 2.2'
gem 'ffi'
gem 'active_storage_validations'

gem 'state_machines-activerecord'
gem 'stripe'