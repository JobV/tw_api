class MeetupRequest < ActiveRecord::Base
  belongs_to :friendship, :inverse_of => :meetup_requests
end
