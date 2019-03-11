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
  describe 'registrar la entrada de un usuario que no existe' do
    it 'returns http user not found error 412 ' do
      get "/api/login/999", headers: {
          'Authorization' => token.to_s
      }
      expect(response).to have_http_status(412)
    end
  end
  describe 'registrar la entrada de un usuario sin autenticarse ' do
    it 'returns http Unauthorized 401 ' do
      get "/api/login/#{user_id}"
      expect(response).to have_http_status(401)
    end
  end

  describe 'registrar la salida de un usuario sin id de entrada' do
    it 'returns http 422' do
      logid = 10
      expect(response).to have_http_status(:success)
      get "/api/logout/#{user_id}", headers: {
          'Authorization' => token.to_s
      }
      expect(response).to have_http_status(422)
    end
  end

  describe 'registrar la salida de usuario que ya salio' do
    it 'returns http 422' do
      get "/api/login/#{user_id}", headers: {
          'Authorization' => token.to_s
      }
      logid = json['id']
      expect(response).to have_http_status(:success)
      get "/api/logout/#{user_id}/#{logid}", headers: {
          'Authorization' => token.to_s
      }
      expect(response).to have_http_status(200)
      get "/api/logout/#{user_id}/#{logid}", headers: {
          'Authorization' => token.to_s
      }
      expect(response).to have_http_status(422)
    end
  end

end
