class AddPowerupFieldsInUsers < ActiveRecord::Migration
  def change
  	add_column :users, :timer_powerup, :integer, default: 2
  	add_column :users, :guideline_powerup, :integer, default: 2
  end
end
