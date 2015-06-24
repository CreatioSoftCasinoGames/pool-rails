class AddFieldsInFriendship < ActiveRecord::Migration
  def change
  	add_column :friendships, :freind_type, :string, default: "fb"
  end
end
