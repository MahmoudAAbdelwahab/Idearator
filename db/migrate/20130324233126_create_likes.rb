class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes, :id => false do |t|
    	t.references :comment
    	t.references :user
      t.timestamps
    end
  end
end
