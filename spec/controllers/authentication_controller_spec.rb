require 'rails_helper'

RSpec.describe AuthenticationController, type: :request do
  let!(:users) { create_list(:user, 2) }
  let(:user) { users.first }
  let(:user_id) { user.id }

  let(:user_id2) { users.last.id }
  # before { post '/auth/login', params: { 'email' => user.email, 'password' => user.password } }
  # let!(:token) { json['auth_token'] }
  before { post '/auth/login', params: { 'email' => user.email, 'password' => user.password } }
  let!(:token) { json['auth_token'] }
  describe 'cuando se autentica mal' do
    it 'retorna http 401 authentication fail' do
      post '/auth/login', params: { 'email' => user.email, 'password' => "55533332222" }
      expect(response).to have_http_status(401)
    end
  end
  describe 'cuando se autentica bien' do
    it 'retorna http 200 success' do
      post '/auth/login', params: { 'email' => user.email, 'password' => user.password }
      expect(response).to have_http_status(:success)
    end
  end
  describe 'cuando crea un usuario sin permiso' do
     it 'return error' do
      post '/auth/create/',
           params: { 'email' => user.email, 'password' => user.password }
      expect(response).to have_http_status(422)
    end
  end
  describe 'cuando crea un usuario que ya existe' do
    before { post '/auth/login', params: { 'email' => user.email, 'password' => user.password } }
    let!(:token) { json['auth_token'] }
    it 'retorna http error' do
      post '/auth/create/',
           params: { 'email' => user.email, 'password' => user.password },
           headers: { 'Authorization' => token.to_s }
      expect(response).to have_http_status(422)
    end
  end
  describe 'cuando crea un usuario correctamente' do
    before { post '/auth/login', params: { 'email' => user.email, 'password' => user.password } }
    let!(:token) { json['auth_token'] }
    it 'retorna http success' do
      post '/auth/create/',
           params: { 'email' => "nuevo@usuario.test", 'password' => "Password*2" },
           headers: { 'Authorization' => token.to_s }
      expect(response).to have_http_status(:success)
    end
  end

end
