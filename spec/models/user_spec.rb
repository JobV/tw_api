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
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'is true' do
    true # test
  end
end
