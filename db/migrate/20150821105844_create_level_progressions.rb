class CreateLevelProgressions < ActiveRecord::Migration
  def change
    create_table :level_progressions do |t|
      t.integer :level
      t.integer :xp_required_to_clear
      t.integer :factor_of_increase
      t.string :award
      t.boolean :cue_unlocked
      t.string :rank

      t.timestamps
    end
  end
end
