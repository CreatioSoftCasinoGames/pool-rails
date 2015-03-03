class CreateFriendRequests < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.integer :user_id
      t.integer :requested_to_id
      t.boolean :confirmed, default: false

      t.timestamps
    end
  end
end
