class AddTotalGamesPlayedAndFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_games_played, :integer
    add_column :users, :flag, :binary
  end
end
