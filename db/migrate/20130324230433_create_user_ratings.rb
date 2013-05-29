class CreateUserRatings < ActiveRecord::Migration
  def change
    create_table :user_ratings, :id => false do |t|
    	t.column :name, :string
    	t.column :value, :integer
    	t.references :user
    	t.references :rating
      t.timestamps
    end
  end
end
