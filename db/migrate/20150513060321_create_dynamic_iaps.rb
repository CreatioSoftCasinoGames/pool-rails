class CreateDynamicIaps < ActiveRecord::Migration
  def change
    create_table :dynamic_iaps do |t|
      t.string :iap_id
      t.decimal :old_coins_value
      t.decimal :new_coins_value
      t.decimal :old_pricing
      t.decimal :new_pricing
      t.boolean :offer
      t.string :currency
      t.string :country

      t.timestamps
    end
  end
end
