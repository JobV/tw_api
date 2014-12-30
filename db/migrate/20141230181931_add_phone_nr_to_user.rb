class AddPhoneNrToUser < ActiveRecord::Migration
  def change
    add_column :users, :phone_nr, :string
  end
end
