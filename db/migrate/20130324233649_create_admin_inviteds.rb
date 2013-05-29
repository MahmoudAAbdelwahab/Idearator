class CreateAdminInviteds < ActiveRecord::Migration
  def change
    create_table :admin_inviteds, :id => false do |t|
    	t.references :admin
    	t.references :invited
      t.timestamps
    end
  end
end
