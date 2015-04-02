require 'rails_helper'

RSpec.describe 'post /api/v1/users/location', type: :request do
  let(:user) { create(:user) }

  context 'post with all params' do
    before do
      token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

      post "/api/v1/users/location", x: '52.440723',
                                     y: '4.809657',
                                     z: '0',
                                     m: '0',
                                     token: token.access_token
    end

    it 'returns 201' do
      expect(response.code).to eq '201'
    end

    it 'returns a message' do
      expect(response.message).to eq 'Created'
    end

    it 'creates a new location' do
      expect(user.locations.count).to eq 1
      expect(user.locations.last.longlat.x).to eq 52.440723
      expect(user.locations.last.longlat.y).to eq 4.809657
      expect(user.locations.last.longlat.z).to eq 0
      expect(user.locations.last.longlat.m).to eq 0
    end
  end

  context 'post with too little params' do
    before do
      token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

      post "/api/v1/users/location", x: "11", token: token.access_token
    end

    it 'returns 500' do
      expect(response.code).to eq '500'
    end

    it 'returns a vague message' do
      expect(response.message).to eq 'Internal Server Error'
    end

    it 'does not create a new location' do
      expect(user.locations.count).to eq 0
    end
  end
end

RSpec.describe 'get /api/v1/users/:id/location', type: :request do
  let(:user) { create(:user) }
  before do
    token = create(:api_key, access_token: "12345678", expires_at: Date.tomorrow, user_id: user.id)

    user.locations.create(
    longlat: "POINT(52.440723 4.809657 0 0)")
    get "/api/v1/users/#{user.id}/location", token: token.access_token
  end

  it 'returns 200' do
    expect(response.code).to eq '200'
  end

  it 'returns the location in json' do
    json = JSON.parse(response.body)
    expect(json['x']).to eq 52.440723
    expect(json['y']).to eq 4.809657
  end
end
