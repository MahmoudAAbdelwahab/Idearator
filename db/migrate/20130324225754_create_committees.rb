class CreateCommittees < ActiveRecord::Migration
  def change
    create_table :committees do |t|
    	t.references :user
      t.timestamps
    end
  end
end
