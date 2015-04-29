class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :token
      t.string :name
      t.string :os
      t.integer :user_id
    end
    add_index :devices, [:token, :user_id], :unique => true
  end
end
