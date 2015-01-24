class CreateMeetupRequests < ActiveRecord::Migration
  def change
    create_table :meetup_requests do |t|
      t.integer :friendship_id
      t.integer :status, :default => 0

      t.timestamps
    end
    add_index :meetup_requests, :friendship_id
  end
end
