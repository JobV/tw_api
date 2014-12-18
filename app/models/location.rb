# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  longlat    :spatial          point, 4326
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
  belongs_to :user
end
