require 'rails_helper'
require 'openssl'
require 'base64'

RSpec.describe "Webhook Verification", type: :request do
  let(:webhook_secret) { Rails.application.credentials.dig(:shopify, :webhook_secret) }
  let(:webhook_url) { "/api/chuds/buy" }
  let(:valid_payload) do
    {
      order: {
        email: "customer@example.com",
        line_items: [
          {
            product: {
              metafields: {
                "gross-prophets" => {
                  "chuds" => "10"
                }
              }
            },
            quantity: 2
          }
        ]
      }
    }.to_json
  end

  def generate_hmac(payload, secret)
    Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', secret, payload))
  end

  context "with a valid HMAC signature" do
    it "authenticates and processes the webhook" do
      hmac = generate_hmac(valid_payload, webhook_secret)

      post webhook_url, params: valid_payload, headers: { "X-Shopify-Hmac-SHA256" => hmac, "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("new chuds")
    end
  end

  context "with an invalid HMAC signature" do
    it "rejects the request as unauthorized" do
      invalid_hmac = "invalidsignature"

      post webhook_url, params: valid_payload, headers: { "X-Shopify-Hmac-SHA256" => invalid_hmac, "CONTENT_TYPE" => "application/json" }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include("Unauthorized")
    end
  end
end
