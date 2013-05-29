class CreateInviteds < ActiveRecord::Migration
  def change
    create_table :inviteds do |t|
    	t.column :email, :string
    	t.column :admin, :boolean
    	t.column :committee, :boolean
      t.timestamps
    end
  end
end
