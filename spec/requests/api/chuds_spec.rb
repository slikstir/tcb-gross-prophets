require 'rails_helper'
require 'openssl'
require 'base64'

RSpec.describe "Chuds Webhook", type: :request do
  let(:webhook_url) { "/api/chuds/buy" }
  let(:shopify_secret) { ENV['SHOPIFY_WEBHOOK_SECRET'] || Rails.application.credentials.dig(:shopify, :webhook_secret) }

  let(:valid_payload) do
    {
      email: "customer@example.com",
      billing_address: { first_name: "John" },
      line_items: [
        { sku: "SHIRT-TT-S", quantity: 2 },
        { sku: "SHIRT-OOPSIE-XS", quantity: 1 }
      ]
    }.to_json
  end

  let(:invalid_payload) { { invalid: "data" }.to_json }

  def generate_hmac(payload, secret)
    Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', secret, payload))
  end

  before do
    # Ensure Product exists in DB
    Product.create!(sku: "SHIRT-TT-S", chuds: 10)
    Product.create!(sku: "SHIRT-OOPSIE-XS", chuds: 5)

    # Ensure Attendee model exists
    Attendee.create!(email: "customer@example.com", name: "John", chuds_balance: 0)
  end

  context "with a valid webhook request" do
    it "allocates chuds to an existing attendee" do
      hmac = generate_hmac(valid_payload, shopify_secret)

      expect {
        post webhook_url, params: valid_payload, headers: {
          "X-Shopify-Hmac-SHA256" => hmac,
          "CONTENT_TYPE" => "application/json"
        }
      }.to change { Attendee.find_by(email: "customer@example.com").chuds_balance }.by(25)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to include("allocated 25 new chuds")
    end
  end

  context "with a new attendee" do
    it "creates a new attendee and allocates chuds" do
      new_payload = {
        email: "new_attendee@example.com",
        billing_address: { first_name: "Steve" },
        line_items: [{ sku: "SHIRT-TT-S", quantity: 1 }]
      }.to_json

      hmac = generate_hmac(new_payload, shopify_secret)

      expect {
        post webhook_url, params: new_payload, headers: {
          "X-Shopify-Hmac-SHA256" => hmac,
          "CONTENT_TYPE" => "application/json"
        }
      }.to change { Attendee.count }.by(1)

      new_attendee = Attendee.find_by(email: "new_attendee@example.com")
      expect(new_attendee.chuds_balance).to eq(110)
      expect(new_attendee.name).to eq("Steve")

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to include("allocated 10 new chuds")
    end
  end

  context "with an invalid webhook signature" do
    it "rejects the request with 401 Unauthorized" do
      post webhook_url, params: valid_payload, headers: {
        "X-Shopify-Hmac-SHA256" => "invalid_hmac",
        "CONTENT_TYPE" => "application/json"
      }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["message"]).to eq("Unauthorized")
    end
  end

  context "with no chuds in order" do
    it "does not allocate chuds" do
      payload_with_no_chuds = {
        email: "customer@example.com",
        billing_address: { first_name: "John" },
        line_items: [{ sku: "NON_EXISTENT_SKU", quantity: 3 }]
      }.to_json

      hmac = generate_hmac(payload_with_no_chuds, shopify_secret)

      expect {
        post webhook_url, params: payload_with_no_chuds, headers: {
          "X-Shopify-Hmac-SHA256" => hmac,
          "CONTENT_TYPE" => "application/json"
        }
      }.not_to change { Attendee.find_by(email: "customer@example.com").chuds_balance }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("No valid chuds in order")
    end
  end
end
