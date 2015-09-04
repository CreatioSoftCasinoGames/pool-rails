class AddNameInDynamicIaps < ActiveRecord::Migration
  def change
  	add_column :dynamic_iaps, :name, :string
  end

  def up
  	change_column :dynamic_iaps, :old_coins_value, :decimal
  	change_column :dynamic_iaps, :new_coins_value, :decimal
  	change_column :dynamic_iaps, :old_pricing, :float
  	change_column :dynamic_iaps, :new_pricing, :float
  	add_column :dynamic_iaps, :iap_type, :string
  	add_column :dynamic_iaps, :is_active, :boolean, default: true
  	add_column :dynamic_iaps, :deal_value, :string
  end
  def down
  	change_column :dynamic_iaps, :old_pricing, :decimal
  	change_column :dynamic_iaps, :new_pricing, :decimal
  	change_column :dynamic_iaps, :old_coins_value, :float
  	change_column :dynamic_iaps, :new_coins_value, :float
  	remove_column :dynamic_iaps, :iap_type
  	remove_column :dynamic_iaps, :is_active
  	remove_column :dynamic_iaps, :deal_value
  end
  
end
