class CreateTagConnections < ActiveRecord::Migration
  def change
    create_table :tag_connections, :force => true, :id => false do |t|
	  t.integer "tag_a_id", :null => false
	  t.integer "tag_b_id", :null => false
    end
  end
end
