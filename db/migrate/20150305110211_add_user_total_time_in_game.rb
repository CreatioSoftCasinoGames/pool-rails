class AddUserTotalTimeInGame < ActiveRecord::Migration
  def change
  	add_column :users, :total_time_in_game, :decimal, default: 0
  end
end
