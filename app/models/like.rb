class Like < ActiveRecord::Base
  attr_accessible :user_id, :comment_id

  belongs_to :user
  belongs_to :comment

end
