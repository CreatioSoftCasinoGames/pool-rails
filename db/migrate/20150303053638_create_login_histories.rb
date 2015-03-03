class CreateLoginHistories < ActiveRecord::Migration
  def change
    create_table :login_histories do |t|
      t.boolean :active
      t.integer :user_id
      t.string :login_token

      t.timestamps
    end
  end
end
