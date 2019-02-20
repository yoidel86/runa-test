require 'rails_helper'

RSpec.describe ApiController, type: :request do
  let!(:users) { create_list(:user, 5) }
  let(:user) { users.first }
  let(:user_id) { user.id }
  before { post '/auth/login', params: { 'email' => user.email, 'password' => user.password } }
  let!(:token) { json['auth_token'] }
  describe 'registrar la entrada y la salida de un usuario' do
    it 'returns http success' do
      get "/api/login/#{user_id}", headers: {
        'Authorization' => token.to_s
      }
      logid = json['id']
      expect(response).to have_http_status(:success)
      get "/api/logout/#{user_id}/#{logid}", headers: {
        'Authorization' => token.to_s
      }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/userlogs/:id' do
    it 'returns http success' do
      get "/api/userlogs/#{user_id}", headers: {
        'Authorization' => token.to_s
      }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/notlogedusers/' do
    before { get "/api/login/#{user_id}", headers: { 'Authorization' => token.to_s } }
    it 'return all users not logedin' do
      get '/api/notlogedusers/', headers: {
        'Authorization' => token.to_s
      }
      expect(json['users'].size).to eq(4)
      expect(response).to have_http_status(:success)
    end
  end
  describe 'GET /api/logedusers/' do
    before { get "/api/login/#{user_id}", headers: { 'Authorization' => token.to_s } }
    it 'return all users not logedin' do
      get '/api/logedusers/', headers: {
        'Authorization' => token.to_s
      }
      expect(json['users'].size).to eq(1)
      expect(response).to have_http_status(:success)
    end
  end
  describe 'GET #users' do
    before { get '/api/users.json', headers: { 'Authorization' => token.to_s } }
    it 'returns users' do
      expect(json).not_to be_empty
      expect(json['users'].size).to eq(5)
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
