class RemoveUnnecessaryColumnsFromSubclasses < ActiveRecord::Migration
  def up
  	remove_column :committees, :user_id
  	remove_column :admins, :user_id
  	add_column :users, :type, :string
  end

  def down
  end
end
