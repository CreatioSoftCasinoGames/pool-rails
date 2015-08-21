class AlterTableOfDynamicIap < ActiveRecord::Migration
  def up
  	rename_column :dynamic_iaps, :old_coins_value, :old_value
  	rename_column :dynamic_iaps, :new_coins_value, :new_value
    change_column :dynamic_iaps, :offer, :string
  	remove_column :dynamic_iaps, :old_pricing
  	remove_column :dynamic_iaps, :new_pricing
  end
  def down
  	rename_column :dynamic_iaps, :old_value, :old_coins_value
  	rename_column :dynamic_iaps, :new_value, :new_coins_value
    change_column :dynamic_iaps, :offer, :boolean
  	add_column :dynamic_iaps, :old_pricing, :decimal
  	add_column :dynamic_iaps, :new_pricing, :decimal
  end
end
