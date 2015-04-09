class AddClubConfigIdToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :club_config_id, :integer
  end
end
