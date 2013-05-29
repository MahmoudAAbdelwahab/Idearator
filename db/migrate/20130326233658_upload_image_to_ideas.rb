class UploadImageToIdeas < ActiveRecord::Migration
 def self.up
    add_attachment :ideas, :photo

  end

  def self.down
    remove_attachment :ideas, :photo
  end
end