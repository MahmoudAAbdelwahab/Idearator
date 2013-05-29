class UserRating < ActiveRecord::Base
  attr_accessible :value, :idea_id
  belongs_to :user
  belongs_to :rating
end
