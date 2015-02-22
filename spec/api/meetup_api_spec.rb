require 'rails_helper'

RSpec.describe 'get /api/v1/users/:id/meetups', type: :request do
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
    end
  end
end

RSpec.describe 'post /api/v1/users/:id/meetups', type: :request do
  let(:user)   { create(:user) }
  let(:friend) { create(:user, first_name: 'Rudolph') }
  let(:device) { create(:device) }

  context 'create meetup with non-friend' do
    before { post "/api/v1/users/#{user.id}/meetups", friend_id: friend.id }
    specify { expect(user.friends.count).to eq 0 }
    specify { expect(response.code).to eq '403' }
  end

  context 'request meetup with friend' do
    before do
      user.friends << friend
      friend.devices << device
      post "/api/v1/users/#{user.id}/meetups", friend_id: friend.id
    end
    specify { expect(response.code).to eq '201' }
    specify { expect(MeetupRequest.last.status).to eq 'pending' }
    specify { expect(MeetupRequest.last.friend).to eq friend }
    specify { expect(MeetupRequest.last.user).to eq user }
  end
end

RSpec.describe 'post /api/v1/users/:id/meetups/accept', type: :request do
  let(:user)   { create(:user) }
  let(:friend) { create(:user, first_name: 'Rudolph') }

  context 'accept recent meetup request with friend' do
    before do
      user.friends << friend
      MeetupRequest.create user_id: friend.id, friend_id: user.id
      post "/api/v1/users/#{user.id}/meetups/accept", friend_id: friend.id
    end

    specify { expect(response.code).to eq '201' }
    specify { expect(MeetupRequest.last.status).to eq 'accepted' }
  end

  context 'accept old meetup request with friend' do
    before do
      user.friends << friend
      MeetupRequest.create(
        user_id: friend.id,
        friend_id: user.id,
        created_at: Time.now - 1.day
      )
      post "/api/v1/users/#{user.id}/meetups/accept", friend_id: friend.id
    end

    specify { expect(response.code).to eq '404' }
  end

  context 'accept non existing meetup request' do
    before { post "/api/v1/users/#{user.id}/meetups/accept", friend_id: 32 }
    specify { expect(response.code).to eq '404' }
  end
end

RSpec.describe 'post /api/v1/users/:id/meetups/decline', type: :request do
  let(:user)   { create(:user) }
  let(:friend) { create(:user, first_name: 'Rudolph') }

  context 'decline most recent meetup request with friend' do
    before do
      user.friends << friend
      MeetupRequest.create user_id: friend.id, friend_id: user.id
      post "/api/v1/users/#{user.id}/meetups/decline", friend_id: friend.id
    end

    specify { expect(response.code).to eq '201' }
    specify { expect(MeetupRequest.last.status).to eq 'declined' }
  end

  context 'decline old meetup request with friend' do
    before do
      user.friends << friend
      MeetupRequest.create(
        user_id: friend.id,
        friend_id: user.id,
        created_at: Time.now - 1.day
      )
      post "/api/v1/users/#{user.id}/meetups/decline", friend_id: friend.id
    end

    specify { expect(response.code).to eq '404' }
  end

  context 'decline non existing meetup request' do
    before { post "/api/v1/users/#{user.id}/meetups/decline", friend_id: 32 }
    specify { expect(response.code).to eq '404' }
  end
end
