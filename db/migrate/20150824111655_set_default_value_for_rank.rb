class SetDefaultValueForRank < ActiveRecord::Migration
  def up
  	change_column :users, :rank, :string, default: "Beginner"
  	add_column :users, :cue_owned, :string
  end
  def down
  	remove_column :users, :cue_owned
  	change_column :users, :rank, :string, default: 0
  end
end
