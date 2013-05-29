class AddCreatedAtToVotes < ActiveRecord::Migration
  def change
    change_table :votes do |t|
      t.timestamps
    end
    add_index :votes, [:idea_id, :user_id], :unique => true
  end
end
