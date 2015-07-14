class AddUniqueIdKeyInUsers < ActiveRecord::Migration
  def change

  	add_column :users, :unique_id, :string, default: ""
  end
end
