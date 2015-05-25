class CreateGameRequests < ActiveRecord::Migration
  def change
    create_table :game_requests do |t|
      t.string :requested_from
      t.string :requested_to
      t.string :invitation_type
      t.boolean :accepted

      t.timestamps
    end
  end
end
