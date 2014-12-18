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

require 'rails_helper'

RSpec.describe Location, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
