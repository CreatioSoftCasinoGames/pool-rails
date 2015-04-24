class AddWinnerXpAndLooserXpToClubConfigs < ActiveRecord::Migration
  def change
    add_column :club_configs, :winner_xp, :integer
    add_column :club_configs, :looser_xp, :integer
  end
end
