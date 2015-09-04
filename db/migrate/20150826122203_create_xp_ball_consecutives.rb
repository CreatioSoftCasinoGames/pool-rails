class CreateXpBallConsecutives < ActiveRecord::Migration
  def change
    create_table :xp_ball_consecutives do |t|
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
