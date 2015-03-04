class AddDeviceAvtarIdInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :device_avtar_id, :string
  end
end
