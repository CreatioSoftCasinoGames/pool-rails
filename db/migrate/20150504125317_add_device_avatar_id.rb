class AddDeviceAvatarId < ActiveRecord::Migration
  def change
  	add_column :users, :device_avatar_id, :integer, default: 0
  end
end
