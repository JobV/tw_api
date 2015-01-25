require 'rails_helper'

RSpec.describe 'get /api/v1/users/:id/meetup', type: :request do
  context 'get pending meetups' do
    let(:user)   { create(:user) }
    let(:friend) { create(:user, first_name: 'Rudolph') }

    before do
      user.friends << friend
      user.request_meetup_with(friend)
      get "/api/v1/users/#{user.id}/friends"

      it 'returns 201' do
        expect(response.code).to eq '201'
      end

      it 'returns 1 result' do
        expect(json.length).to eq 1
      end

      it 'returns meetup id' do
      puts json
      end

    end

  end
end

RSpec.describe 'post /api/v1/users/:id/meetup', type: :request do
  let(:user)   { create(:user) }
  let(:friend) { create(:user, first_name: 'Rudolph') }



  context 'create meetup with friend' do
    before do
      user.friends << friend
      post "/api/v1/users/#{user.id}/meetups",
      friend_id: friend.id
    end

    it 'returns 201' do
      expect(response.code).to eq '201'
    end

    it 'returns 1 result' do
      expect(json.length).to eq 1

    end

    it 'returns success when valid relationship' do
      expect(json['success']).to eq true
    end

  end

end
