class AddFieldInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :is_guest, :boolean, default: false
  	add_column :users, :online, :boolean, default: false
  end
end
