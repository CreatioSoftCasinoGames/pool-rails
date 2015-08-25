class AddNameInDynamicIaps < ActiveRecord::Migration
  def change
  	add_column :dynamic_iaps, :name, :string
  end
end
