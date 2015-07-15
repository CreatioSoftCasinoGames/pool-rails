class AddGuidelinesToClubConfigs < ActiveRecord::Migration
  def change
  add_column :club_configs, :guideline_status, :boolean
  end
end
