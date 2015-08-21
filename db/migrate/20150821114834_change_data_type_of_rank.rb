class ChangeDataTypeOfRank < ActiveRecord::Migration
  def up
  	change_column :users, :rank, :string
  end
  def down
  	change_column :users, :rank, :integer
  end
end
