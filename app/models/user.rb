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
    friends.joins(:locations).where("ST_DWithin(longlat, ST_Geographyfromtext('#{current_location.longlat}'), 1000)")
  end

  def register_interaction_with(other_user)
    friendships = Friendship.where("user_id=#{id} and friend_id= #{other_user.id} or
                                  user_id=#{other_user.id} and friend_id= #{id}")
    friendships.each do |entry|
      entry.interaction_counter ? entry.interaction_counter += 1 : entry.interaction_counter = 1
      entry.save
    end
  end

  def current_location
    locations.last
  end
end
