require 'rails_helper'

RSpec.describe 'get /api/v1/location', type: :request do
  let(:user) { create(:user) }

  context 'post with all params' do
    before do
      post '/api/v1/location',
        x: '52.440723',
        y: '4.809657',
        z: '0',
        m: '0',
        id: "#{user.id}"
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
      post '/api/v1/location',
      id: "#{user.id}"
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
