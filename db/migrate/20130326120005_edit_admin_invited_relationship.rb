class EditAdminInvitedRelationship < ActiveRecord::Migration
	# adds a foriegn key for the admin in the invited table
 def change
  change_table :inviteds do |t|
  t.references :admin
   end
 end
end
