class AddFieldsInFriendship < ActiveRecord::Migration
  def change
  	add_column :friendships, :friend_type, :string, default: "fb"
  end
end
