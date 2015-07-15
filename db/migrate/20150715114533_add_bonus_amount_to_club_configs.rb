class AddBonusAmountToClubConfigs < ActiveRecord::Migration
  def change
	add_column :club_configs, :bonus_amount, :integer
  	
  end
end
