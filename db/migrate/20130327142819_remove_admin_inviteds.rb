class RemoveAdminInviteds < ActiveRecord::Migration
  def up
  	drop_table :admin_inviteds
  end

  def down
  end
end
