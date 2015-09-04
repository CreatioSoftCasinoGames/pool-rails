class CreateXpBallPottedOnWinnings < ActiveRecord::Migration
  def change
    create_table :xp_ball_potted_on_winnings do |t|
      t.integer :oneball
      t.integer :twoball
      t.integer :threeball
      t.integer :fourball
      t.integer :fiveball
      t.integer :sixball
      t.integer :sevenball

      t.timestamps
    end
  end
end
