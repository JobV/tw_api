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

require 'rails_helper'

RSpec.describe Friendship, :type => :model do
end
