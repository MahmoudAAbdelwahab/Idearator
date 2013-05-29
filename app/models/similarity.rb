class Similarity < ActiveRecord::Base
  belongs_to :idea
  belongs_to :similar_idea, class_name: 'Idea'
  attr_accessible :similarity

  default_scope order('similarity DESC')
end
