class AddIntegrationCounterToFriendship < ActiveRecord::Migration
  def change
    add_column :friendships, :interaction_counter, :integer
  end
end
