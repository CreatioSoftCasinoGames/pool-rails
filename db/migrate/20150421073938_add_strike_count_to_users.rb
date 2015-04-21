class AddStrikeCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :strike_count, :float, default: 0
  end
end
