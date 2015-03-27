class AddDefaultToRole < ActiveRecord::Migration
  def change
    change_column_default(:users, :role, "standard")
  end
end