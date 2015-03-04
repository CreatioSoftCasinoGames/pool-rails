class AddProfileDataInUsers < ActiveRecord::Migration
  def change
    add_column :users, :won_count, :integer, default: 0
    add_column :users, :lost_count, :integer, default: 0
    add_column :users, :rank, :integer, default: 0
    add_column :users, :total_coins_won, :decimal, default: 0
    add_column :users, :win_percentage, :decimal, default: 0
    add_column :users, :total_tournament_won, :integer, default: 0
    add_column :users, :total_tournament_played, :integer, default: 0
    add_column :users, :win_streak, :integer, default: 0
    add_column :users, :ball_potted, :decimal, default: 0
    add_column :users, :accuracy, :decimal, default: 0
    add_column :users, :xp, :integer, default: 0
    add_column :users, :current_level, :integer, default: 1
    add_column :users, :country, :string
    add_column :users, :achievement, :string
    add_column :users, :current_coins_balance, :decimal, default: 1000
    add_column :users, :is_dummy, :boolean, default: false
  end
end
