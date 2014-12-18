class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.point :longlat, geographic: true, has_z: true, has_m: true
      t.belongs_to :user

      t.index :longlat, spatial: true

      t.timestamps
    end
    add_index :locations, :user_id
  end
end
