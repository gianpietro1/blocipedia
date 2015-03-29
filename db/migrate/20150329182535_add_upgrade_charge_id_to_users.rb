class AddUpgradeChargeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :upgrade_charge_id, :string
  end
end
