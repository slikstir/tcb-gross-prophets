require 'rails_helper'

RSpec.describe "Apis Hello World", type: :request do
  describe "GET /apis" do
    it "works! (now write some real specs)" do
      get '/api'
      expect(response).to have_http_status(200)
    end
  end
end