class RemoveColumnFromGameRequest < ActiveRecord::Migration
  def up
  	remove_column :game_requests, :game_id
  	remove_column :game_requests, :requested_from
  	add_column :game_requests, :club_config_id, :integer
  	change_column :game_requests, :requested_to, :integer
  end
  def down
  	add_column :game_requests, :game_id, :integer
  	add_column :game_requests, :requested_from, :integer
  	change_column :game_requests, :requested_to, :string
  end
end
