require 'rails_helper'

RSpec.describe FrontController, type: :request do
  let!(:users) { create_list(:user, 5) }
  let(:user) { users.first }
  describe 'GET #index without login' do
    it 'returns http redirect to login' do
      get "/index"
      expect(response).to have_http_status(302)
    end
  end
  describe 'GET #index after login' do
    before { post '/auth/login', params: { 'email' => user.email, 'password' => user.password } }
    let!(:token) { json['auth_token'] }
    it 'returns http success' do
      get "/index", headers: {
          'Authorization' => token.to_s
      }
      expect(response).to have_http_status(:success)
    end
  end
end
