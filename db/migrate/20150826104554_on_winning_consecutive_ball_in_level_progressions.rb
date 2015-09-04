class OnWinningConsecutiveBallInLevelProgressions < ActiveRecord::Migration
  def change
   add_column :level_progressions, :on_winning, :integer
   add_column :level_progressions, :consecutive_ballshot, :integer
  end
end
