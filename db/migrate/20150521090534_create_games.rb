class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :club_config_id
      t.integer :winner_id
      t.integer :looser_id

      t.timestamps
    end
  end
end
