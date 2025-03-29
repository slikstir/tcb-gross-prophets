class ApplicationMailer < ActionMailer::Base
  default from: 'hello@tincanbros.com'
  layout 'mailer'

  include Rails.application.routes.url_helpers

  def default_url_options
    { host: "localhost", port: 3000 }
  end
end

