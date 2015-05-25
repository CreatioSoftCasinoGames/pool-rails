class CreateFriendRequests < ActiveRecord::Migration
  def change
    create_table :friend_requests do |t|
      t.integer :requested_to_id
      t.boolean :confirmed, default: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
