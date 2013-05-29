class AddPrimaryKeyToUserRatings < ActiveRecord::Migration
  def change
    add_column :user_ratings, :id, :primary_key
  end
end
