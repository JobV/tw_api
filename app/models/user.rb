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

  validates :phone_nr, uniqueness: true

  def curated_friends_list
    friends.joins(:locations)
          .where("ST_DWithin(longlat, ST_Geographyfromtext('#{current_location.longlat}'), 300000)")
          .order("friendships.interaction_counter DESC")
          .limit(10)
  end

  def increment_interaction_with(other_user)
    friendship = Friendship.where("user_id=#{id} and friend_id=#{other_user.id}").first
    friendship.increment!(:interaction_counter)
  end

  def number_of_interactions_with(other_user)
    friendship = Friendship.where("user_id=#{id} and friend_id=#{other_user.id}").first
    friendship.interaction_counter
  end

  def current_location
    locations.last
  end

  def request_meetup_with(other_user)
    meetup_req = MeetupRequest.new
    meetup_req.friendship = Friendship.where(user_id: id, friend_id: other_user.id).first
    meetup_req.save
  end

  def meetup_requests
    MeetupRequest.joins(:friendship).where(friendships: { friend_id: id }, status: 0)
  end

  def meetup_history
    MeetupRequest.joins(:friendship).where(friendships: { friend_id: id })
  end

end
