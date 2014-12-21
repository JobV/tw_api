require 'rails_helper'

RSpec.describe 'get /api/v1/location', type: :request do
  let(:user) { create(:user) }
  context 'post with all params' do
    it 'creates a new location' do
      post '/api/v1/location',
        x: '52.440723',
        y: '4.809657',
        z: '0',
        m: '0',
        id: "#{user.id}"
      expect(user.locations.count).to eq 1
      expect(user.locations.last.longlat.x).to eq 52.440723
    end
  end
end
