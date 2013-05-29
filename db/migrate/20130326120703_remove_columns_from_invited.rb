class RemoveColumnsFromInvited < ActiveRecord::Migration
	# removes unnecessary columns from the table invited
  def up
  	remove_column :inviteds, :committee
  	remove_column :inviteds, :admin
  end

  def down
  end
end
