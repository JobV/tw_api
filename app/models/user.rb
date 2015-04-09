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

class User < ActiveRecord::Base
  has_many :locations
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :devices, inverse_of: :user

  def curated_friends_list
    friends.joins(:locations)
      .where("ST_DWithin(longlat, ST_Geographyfromtext('#{current_location.longlat}'), 300000)")
      .order("friendships.interaction_counter DESC")
      .limit(10)
  end

  def increment_interaction_with(user)
    friendship_with(user).increment!(:interaction_counter)
  end

  def number_of_interactions_with(user)
    friendship_with(user).interaction_counter
  end

  def current_location
    locations.last
  end

  def friends_with?(friend)
    friends.exists?(friend)
  end

  def request_meetup_with(user)
    meetup_req = MeetupRequest.new
    meetup_req.friendship = friendship_with(user)
    meetup_req.pending!
    meetup_req.save
  end

  def ongoing_meetups
    MeetupRequest
      .joins(:friendship)
      .where("(friendships.friend_id = ? or friendships.user_id = ?) and status = ?", id, id, 1)
  end

  def pending_meetup_requests_received
    meetups = MeetupRequest.joins(:friendship).where(friendships: { friend_id: id }, status: 0)
    meetups_response_format_for(meetups)
  end

  def pending_meetup_requests_sent
    meetups = MeetupRequest.joins(:friendship).where(friendships: { user_id: id }, status: 0)
    meetups_response_format_for(meetups)
  end

  def meetup_history
    meetups = MeetupRequest.joins(:friendship).where(friendships: { friend_id: id })
    meetups_response_format_for(meetups)
  end

  private

  def meetups_response_format_for(meetups)
    array = []
    meetups.each do |meetup|
      array << [friend_id: meetup.friendship.user_id, meetup_id: meetup.id, created_date: meetup.created_at]
    end
    array
  end

  def friendship_with(user)
    friendships.find_by(friend: user.id)
  end
end
