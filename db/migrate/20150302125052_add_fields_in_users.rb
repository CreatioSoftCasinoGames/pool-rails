class AddFieldsInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :first_name, :string
  	add_column :users, :last_name, :string
  	add_column :users, :fb_id, :string
  	add_column :users, :device_id, :string
  	add_column :users, :login_token, :string
  end
end
