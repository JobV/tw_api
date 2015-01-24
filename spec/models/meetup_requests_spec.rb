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

require 'rails_helper'

RSpec.describe MeetupRequest, :type => :model do

end
