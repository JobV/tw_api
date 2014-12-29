require 'rails_helper'

RSpec.describe 'get /api/v1/users/:id/friends', type: :request do
  context 'user has 3 friends' do
    let(:user) { create(:user) }

    before do
      user.friends << create(:user, first_name: 'Marcelo')
      user.friends << create(:user, first_name: 'Carla')
      user.friends << create(:user, first_name: 'Job')

      get "/api/v1/users/#{user.id}/friends"
    end
    it 'returns 200' do
      expect(response.code).to eq '200'
    end
    it 'returns 3 friends' do
      expect(json.length).to eq 3
    end

    it 'returns the right attributes' do
      expect(json[1]['last_name']).to eq 'Doe'
      expect(json[1]['first_name']).to be
    end
  end
end
