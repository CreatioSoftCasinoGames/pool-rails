class AddRuleIdAndActiveToClubConfigs < ActiveRecord::Migration
  def change
    add_column :club_configs, :rule_id, :integer
    add_column :club_configs, :active, :boolean
  end
end
