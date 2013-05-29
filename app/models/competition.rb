class Competition < ActiveRecord::Base

  attr_accessible :title, :description ,:start_date ,:end_date, :tag_ids

  validates_length_of :title, :maximum => 50
  validates_length_of :description, :maximum => 1000

  belongs_to :investor
  has_many :competition_entries
  has_many :ideas, :through => :competition_entries, :source => :idea, :conditions => ['competition_entries.approved = ?',true]
  belongs_to :winner, :class_name => 'Idea', :foreign_key => 'idea_id'
  has_and_belongs_to_many :tags
  has_many :competition_notifications, :dependent => :destroy
  has_many :competition_idea_notifications, :dependent => :destroy
  has_many :delete_competition_notifications

  def filter
    @ideas = []
    tags=self.tags
    tags.each do |tag|
      t = Tag.find(:first, :conditions => {:name => tag.name})
      ideatags = IdeasTags.find(:all, :conditions => {:tag_id => t.id})
      ideas = Idea.where(:id => ideatags.map(&:idea_id))
      @ideas = @ideas + ideas
    end
    @ideas
  end

  # check if a competition is still open
  # Params
  # +self+:: the current +Competition+ that we want to check
  # Muhamed Hassan
  def open
    return  start_date <= Time.now.to_date && end_date >= Time.now.to_date
  end

  def send_create_notification(investor)
    @users= User.where(:id => @ideas.map(&:user_id))
    puts @users
    CreateCompetitionNotification.send_notification(investor,self,@users)
  end

  def send_edit_notification(investor)
   users=User.where(:id => self.ideas.map(&:user_id))
    EditCompetitionNotification.send_notification(investor,self,users)
  end

  def send_delete_notification(investor)
    users=User.where(:id => self.ideas.map(&:user_id))
    DeleteCompetitionNotification.send_notification(investor,self,users)
  end


end
