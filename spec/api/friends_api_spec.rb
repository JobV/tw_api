require 'rails_helper'

RSpec.describe 'get /api/v1/users/friends', type: :request do
  context 'user has 3 friends' do
    let(:user) { create(:user) }

    before do
      user.friends << create(:user, first_name: 'Marcelo', provider: 'facebook', provider_id: '123')
      user.friends << create(:user, first_name: 'Carla', provider: 'facebook', provider_id: '456')
      user.friends << create(:user, first_name: 'Job', provider: 'facebook', provider_id: '789')
      token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

      get "/api/v1/users/friends", token: token.access_token
    end
    it 'returns 200' do
      expect(response.code).to eq '200'
    end
    it 'returns 3 friends' do
      expect(json.length).to eq 3
    end

    it 'returns the right attributes' do
      expect(json[1]['provider']).to eq 'facebook'
      expect(json[1]['provider_id']).to eq '456'
      expect(json[1]['last_name']).to eq 'Doe'
      expect(json[1]['first_name']).to be
    end
  end
end

RSpec.describe 'post /api/v1/users/friends', type: :request do
  let(:user)   { create(:user) }
  let(:friend) { create(:user, first_name: 'Rudolph') }
  let(:friend2) { create(:user) }
  let(:friend3) { create(:user) }

  context 'add a single friend that exists' do
    before do
      token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

      post "/api/v1/users/friends", phone_nrs: ["#{friend.phone_nr}"], token: token.access_token
    end

    it 'returns 201' do
      expect(response.code).to eq '201'
    end

    it 'adds a friend to the user' do
      expect(user.friends.count).to eq 1
      expect(user.friends.first.first_name).to eq 'Rudolph'
    end
  end

  context 'add multiple friends that exist' do
    before do
      token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

      post "/api/v1/users/friends", phone_nrs: [friend.phone_nr, friend2.phone_nr, friend3.phone_nr], token: token.access_token
    end

    it 'returns 201' do
      expect(response.code).to eq '201'
    end

    it 'adds the friends to the user' do
      expect(user.friends.count).to eq 3
    end
  end

  context 'add some friends that exist and others that dont' do
    before do
      token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

      post "/api/v1/users/friends", phone_nrs: [friend.phone_nr, friend2.phone_nr, '0000123'], token: token.access_token
    end

    it 'returns 201' do
      expect(response.code).to eq '201'
    end

    it 'adds the friends to the user' do
      expect(user.friends.count).to eq 2
    end
  end

  context 'add one friend that does not exist' do
    before do
      token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

      post "/api/v1/users/friends", phone_nrs: ['0000123'], token: token.access_token
    end

    it 'returns 201' do
      expect(response.code).to eq '201'
    end

    it 'adds no friends to the user' do
      expect(user.friends.count).to eq 0
    end
  end
end
