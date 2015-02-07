# == Schema Information
#
# Table name: meetup_requests
#
#  id            :integer          not null, primary key
#  friendship_id :integer
#  status        :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class MeetupRequest < ActiveRecord::Base
  belongs_to :friendship, inverse_of: :meetup_requests
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  enum status: [:pending, :accepted, :declined]
end
