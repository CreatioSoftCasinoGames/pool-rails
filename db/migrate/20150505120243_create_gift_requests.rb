class CreateGiftRequests < ActiveRecord::Migration
  def change
    create_table :gift_requests do |t|
      t.integer :user_id
      t.integer :send_to_id
      t.boolean :confirmed, default: false
      t.boolean :is_asked, default: false
      t.string :gift_type, null: false
      t.decimal :gift_value, :decimal, default: 5

      t.timestamps
    end
  end
end
