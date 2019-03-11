require 'rails_helper'

RSpec.describe ApiController, type: :request do
  let!(:users) { create_list(:user, 5) }
  let(:user) { users.first }
  let(:user_id) { user.id }

  let(:user_id2) { users.last.id }
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

  describe 'GET /api/user_logs/:id' do
    it 'returns http success' do
      get "/api/user_logs/#{user_id}", headers: {
        'Authorization' => token.to_s
      }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/not_logged_users/' do
    before { get "/api/login/#{user_id}", headers: { 'Authorization' => token.to_s } }
    it 'return all users not logedin' do
      get '/api/not_logged_users/', headers: {
        'Authorization' => token.to_s
      }
      expect(json['users'].size).to eq(4)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/logged_users/' do
    before { get "/api/login/#{user_id}", headers: { 'Authorization' => token.to_s } }
    it 'return all users not logedin' do
      get '/api/logged_users/', headers: {
        'Authorization' => token.to_s
      }
      expect(json['users'].size).to eq(1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/day_logged_users/' do
    before {
      get "/api/login/#{user_id}", headers: { 'Authorization' => token.to_s }
      log_id = json['id']
      get "/api/logout/#{user_id}/#{log_id}", headers: { 'Authorization' => token.to_s }
    }
    it 'return all users not logedin' do
      get '/api/day_logged_users/', headers: {
          'Authorization' => token.to_s
      }
      expect(json['users'].size).to eq(1)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET save_report by user ' do
    before {
      # registrando login de usuario
      get "/api/login/#{user_id}", headers: { 'Authorization' => token.to_s }
      log_id = json['id']
      # registrando logout de usuario
      get "/api/logout/#{user_id}/#{log_id}", headers: { 'Authorization' => token.to_s }
    }

    it 'generated report fo user' do
      date = Date.today
      post "/api/save_report",params:{
          user_id:user_id,
          start_date:date-1.day,
          end_date:date+1.day
      }, headers: {
          'Authorization' => token.to_s
      }
      expect(json['logs'].size).to eq(1)
      expect(response).to have_http_status(:success)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'get generate report' do
    before {
      get "/api/login/#{user_id}", headers: { 'Authorization' => token.to_s }
      log_id = json['id']
      date = Date.today
      get "/api/logout/#{user_id}/#{log_id}", headers: { 'Authorization' => token.to_s }
      post "/api/save_report",params:{ user_id:user_id, start_date: date-1.day, end_date: date+1.day }, headers: {
          'Authorization' => token.to_s
      }
    }
    it 'get generated report fo user #get_user_reports'  do
      get "/api/get_user_reports",params:{
          user_id:user_id
      }, headers: {
          'Authorization' => token.to_s
      }
      p json
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #users' do
    before { get '/api/users.json', headers: { 'Authorization' => token.to_s } }
    it 'returns report' do
      expect(json).not_to be_empty
      expect(json['users'].size).to eq(5)
    end
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
