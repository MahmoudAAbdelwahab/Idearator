class AddFacebooksettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_share, :boolean, :default => true
  end
end
