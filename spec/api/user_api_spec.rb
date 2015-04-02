require 'rails_helper'

RSpec.describe 'get /api/v1/users', type: :request do
  context 'when the user exists' do
    let(:user) { create(:user) }
    before do
      token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

      get "/api/v1/users", token: token.access_token
    end

    specify { expect(response.code).to eq '200' }

    it 'returns the users properties' do
      expect(json['first_name']).to eq 'John'
    end
  end

  context 'when the user does not exist' do
    before do
      token = create(:api_key, access_token: "1A2B3C", expires_at: Date.tomorrow)

      get "/api/v1/users", token: token.access_token
    end
    specify { expect(response.code).to eq '500' }
  end
end

RSpec.describe 'post /api/v1/users', type: :request do
  context 'given all parameters' do
    before do
      token = create(:api_key, access_token: "1A2B3C", expires_at: Date.tomorrow)

      post '/api/v1/users', first_name: 'Luke',
                            last_name: 'Skywalker',
                            email: 'luke@theforce.com',
                            phone_nr: '123123123',
                            token: token.access_token
    end

    it 'creates a new user' do
      expect(response.code).to eq '201'
      user = User.last
      expect(user.first_name).to eq 'Luke'
      expect(user.last_name).to eq 'Skywalker'
      expect(user.email).to eq 'luke@theforce.com'
    end
  end

  context 'given missing parameter' do
    before do
      token = create(:api_key, access_token: "1A2B3C", expires_at: Date.tomorrow)

      post '/api/v1/users', first_name: 'Luke', token: token.access_token
    end

    it 'returns 500' do
      expect(response.code).to eq '500'
    end
  end
end
