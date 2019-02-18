require 'rails_helper'

RSpec.describe ApiController, type: :request do
  let!(:users) { create_list(:user, 5) }
  let(:user_id) { users.first.id }
  describe "GET #login" do
    it "returns http success" do
      get '/api/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #logout" do
    it "returns http success" do
      get '/api/logout'
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /api/userlogs/:id" do
    it "returns http success" do
      get "/api/userlogs/#{user_id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #users" do
    before { get '/api/users.json' }
    it 'returns users' do
      expect(json).not_to be_empty
      expect(json.size).to eq(5)
    end
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
  end

end
