class Comment < ActiveRecord::Base
  attr_accessible :content, :idea_id , :num_likes
  validates :content, :presence=> true
  belongs_to :idea
  belongs_to :user
  has_and_belongs_to_many :likes, :class_name => 'User', :join_table => :likes
end
