class AddRoomTypeInXpBallPotted < ActiveRecord::Migration
  def change
add_column :xp_ball_potted_on_winnings, :room_type, :string
  end
end
