class AddIsFbConnectedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_fb_connected, :boolean, default: false
  end
end
