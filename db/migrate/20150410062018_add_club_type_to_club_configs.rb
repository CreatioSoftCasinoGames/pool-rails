class AddClubTypeToClubConfigs < ActiveRecord::Migration
  def change
    add_column :club_configs, :club_type, :string
  end
end
