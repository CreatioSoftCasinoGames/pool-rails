class AddRoomTypeInClubConfig < ActiveRecord::Migration
  def change
  	add_column :club_configs, :room_type, :string
  end
end
