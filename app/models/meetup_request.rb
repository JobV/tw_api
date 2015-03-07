# == Schema Information
#
# Table name: meetup_requests
#
#  id            :integer          not null, primary key
#  friendship_id :integer
#  status        :integer          default(0)
#  created_at    :datetime
#  updated_at    :datetime
#  user_id       :integer
#  friend_id     :integer
#

class MeetupRequest < ActiveRecord::Base
  belongs_to :friendship, inverse_of: :meetup_requests
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  enum status: [:pending, :accepted, :declined, :terminated]

  def has_finished?
    status == "terminated" || status == "declined"
  end

  def is_pending?
    status == "pending"
  end
end
