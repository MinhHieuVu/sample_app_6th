require 'rails_helper'

RSpec.describe "Emotes", type: :request do
  describe "GET /emoji" do
    it "returns http success" do
      get "/emotes/emoji"
      expect(response).to have_http_status(:success)
    end
  end

end
