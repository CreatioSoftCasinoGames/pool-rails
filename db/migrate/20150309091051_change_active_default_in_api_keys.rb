class ChangeActiveDefaultInApiKeys < ActiveRecord::Migration
  def change
  	change_column :api_keys, :active, :boolean, default: true
  end
end
