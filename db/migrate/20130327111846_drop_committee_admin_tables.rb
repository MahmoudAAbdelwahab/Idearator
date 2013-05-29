class DropCommitteeAdminTables < ActiveRecord::Migration
  def up
  	drop_table :admins
  	drop_table :committees
  end

  def down
  end
end
