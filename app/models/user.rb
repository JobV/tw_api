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
    #current_user.friends.where{"ST_DWithin(longlat, ST_Geographyfromtext('POINT(#{x} #{y})'), 1000)"}
    friends.where{"ST_DWithin(longlat, ST_Geographyfromtext('POINT(#{x} #{y})'), 1000)"}
  end
end
