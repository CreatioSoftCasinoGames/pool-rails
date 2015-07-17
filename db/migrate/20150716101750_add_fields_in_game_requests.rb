class AddFieldsInGameRequests < ActiveRecord::Migration
  def change
  	add_column :game_requests, :acceptance_by_user_at, :datetime
  	add_column :game_requests, :acceptance_by_requester_at, :datetime
  end
end
