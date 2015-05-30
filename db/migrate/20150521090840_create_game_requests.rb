class CreateGameRequests < ActiveRecord::Migration
  def change
    create_table :game_requests do |t|
    	t.integer :user_id
      t.integer :game_id
      t.string :requested_from
      t.string :requested_to
      t.string :invitation_type
      t.boolean :accepted,      default: false

      t.timestamps
    end
  end
end
