require 'rails_helper'

RSpec.describe "Apis Hello World", type: :request do
  let(:user) { create(:user) }

  describe "GET /api" do
    it "returns 200 OK with valid API token" do
      get '/api', headers: {
        "Authorization" => "Token #{user.api_token}"
      }

      expect(response).to have_http_status(200)
    end
  end
end