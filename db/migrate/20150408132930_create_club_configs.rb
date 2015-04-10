class CreateClubConfigs < ActiveRecord::Migration
  def change
    create_table :club_configs do |t|
      t.string :name
      t.decimal :entry_fees
      t.decimal :winner_amount

      t.timestamps
    end
  end
end
