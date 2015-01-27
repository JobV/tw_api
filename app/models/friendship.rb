# == Schema Information
#
# Table name: friendships
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  friend_id           :integer
#  created_at          :datetime
#  updated_at          :datetime
#  interaction_counter :integer          default(0)
#

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  has_many :meetup_requests, :inverse_of => :friendship
end
