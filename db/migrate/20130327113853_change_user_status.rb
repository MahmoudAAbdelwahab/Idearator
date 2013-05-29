class ChangeUserStatus < ActiveRecord::Migration
  #remove the vague column status and add two boolean columns "active" and "banned"
  def up
  	remove_column :users, :status
  	add_column :users, :active, :boolean, :default => true
  	add_column :users, :banned, :boolean, :default => false
  end

  def down
  end
end
