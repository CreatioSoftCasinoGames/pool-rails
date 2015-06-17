class AddUserPoolIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_pool_id, :string
  end
end
