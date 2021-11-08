require 'rails_helper'

RSpec.describe 'V1::Sessions', type: :request do
  let(:user) { create(:user) }
  describe 'POST /v1/login' do
    context 'with user' do
      it 'returns http success' do
        post '/v1/login', params: { email: user.email }
        expect(response).to have_http_status(:success)
      end

      it 'returns http unauthorized wrong email' do
        post '/v1/login', params: {email: 'wrong@gmail.com'}
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns http unauthorized user locked' do
        user.locked!
        post '/v1/login', params: { email: user.email }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /v1/logout' do
    context 'with user' do
      it 'valid token returns http success' do
        post '/v1/login', params: { email: user.email }
        token = JSON.parse(response.body)['user']['token']

        delete '/v1/logout', headers: {'Authentication': token}
        expect(response).to have_http_status(:success)
      end
    end

    it 'invalid token returns http unauthorized' do
      token = 'invalid_token'

      delete '/v1/logout', headers: { 'Authentication': token }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'none token returns http unauthorized' do
      delete '/v1/logout'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
