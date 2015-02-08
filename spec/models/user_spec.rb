# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  phone_nr   :string(255)
#

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'interactions' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    it 'returns 0 as the number of interactions between two new friends' do
      user.friends << friend
      expect(user.number_of_interactions_with(friend)).to eq(0)
    end

    it 'increment counter by one point' do
      user.friends << friend
      expect { user.increment_interaction_with(friend) }.to change { user.number_of_interactions_with(friend) }.from(0).to(1)
    end
  end

  context 'curated list of friends' do
    let(:user) { create(:user) }

    before do
      user.locations.create!(longlat: "POINT(38.923341 -9.231600)")
      15.times do |i|
        friend = create(:user, first_name: "nearby_friend#{i}")
        friend.locations.create!(longlat: "POINT(38.923341 -9.231600)")
        user.friends << friend
      end
      10.times do |i|
        friend = create(:user, first_name: "faraway_friend#{i}")
        friend.locations.create!(longlat: "POINT(40.923341 -9.231600)")
        user.friends << friend
      end
    end

    it 'only returns friends within 300km' do
      user.curated_friends_list.each do |friend|
        expect(friend.current_location.longlat.to_s).to eq("POINT (38.923341 -9.2316 0.0 0.0)")
      end
    end

    it 'limits the max number of curated friends to 10' do
      expect(user.curated_friends_list.count).to eq(10)
    end

    it 'orders list of friends by number of interactions (descending order)' do
      friend = user.friends.where(first_name: "nearby_friend1").first
      user.increment_interaction_with(friend)
      expect(user.curated_friends_list.first.first_name).to eq("nearby_friend1")
    end
  end

  context 'receiving meetup requests' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    before do
      user.friends << friend
      friendship = Friendship.last
      MeetupRequest.create!(friendship_id: friendship.id, status: 0)
    end

    it 'adds entry to pending meetup requests received list' do
      expect(friend.pending_meetup_requests_received.count).to eq(1)
    end

    it 'adds entry to pending meetup requests sent list' do
      expect(user.pending_meetup_requests_sent.count).to eq(1)
    end
  end
end
