class CreateUsers < ActiveRecord::Migration
  def change
        create_table :users do |t|
    	t.column :email, :string, :limit => 100, :null => false
    	t.column :password, :string
        t.column :first_name, :string
        t.column :last_name, :string
        t.column :username, :string
        t.column :date_of_birth, :date
        t.column :gender, :string, :limit => 1
        t.column :about_me, :text
        t.column :recieve_vote_notification, :boolean, :default => true
        t.column :recieve_comment_notification, :boolean, :default => true
        t.column :status, :string
      t.timestamps
    end
  end
end
