class AddMoreEndTimeInDynamicIaps < ActiveRecord::Migration
  def change

add_column :dynamic_iaps, :more, :integer
add_column :dynamic_iaps, :end_time, :integer

  end
end
