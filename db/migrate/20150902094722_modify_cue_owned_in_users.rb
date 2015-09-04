class ModifyCueOwnedInUsers < ActiveRecord::Migration
  def change
  change_column :users, :cue_owned, :string, default: ""
  end
end
