class Device < ActiveRecord::Base
  belongs_to :user, :inverse_of => :devices
end
