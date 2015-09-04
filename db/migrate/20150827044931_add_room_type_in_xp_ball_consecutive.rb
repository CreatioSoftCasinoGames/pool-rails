class AddRoomTypeInXpBallConsecutive < ActiveRecord::Migration
  def change

  	add_column :xp_ball_consecutives, :room_type, :string
  end
end
