class Committee < User
  # attr_accessible :title, :body
  has_many :approved_ideas, :class_name => 'Idea'
  has_and_belongs_to_many :tags

  #This method maps the Committee to the superclass User
  #params:
  #none
  #Author: Hisham ElGezeery
  def self.model_name
    User.model_name
  end

end
