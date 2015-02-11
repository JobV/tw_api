class AddUserAndFriendToMeetupRequests < ActiveRecord::Migration
  def change
    add_column :meetup_requests, :user_id, :integer
    add_column :meetup_requests, :friend_id, :integer
  end
end
