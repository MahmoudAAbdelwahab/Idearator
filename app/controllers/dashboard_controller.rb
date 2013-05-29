class DashboardController < ApplicationController
  before_filter :authenticate_user!, :only => [:index]

  # renders the view of the dashboard for idea submitters and committee members.
  # it checks the value of the current threshold, the user's ideas and committee's
  # approved ideas and calculates the corresponding percentage of the ideas in relation
  # to the threshold.
  # Params:
  # none
  # Author: Hisham ElGezeery

  def index
    @user = current_user
    @threshold = Threshold.last
    if @user.type == 'Committee'
      @approved_ideas = Idea.find(:all, :conditions => { :committee_id => @user.id, :archive_status => false})

      @approved_thresholds = Array.new
      @approved_ideas.each do |idea|
        user = idea.user
        if !user.banned && user.active
          @v = VoteCount.find(:first, :conditions => { :idea_id => idea.id})
          @approved_threshold = ((@v.prev_day_votes * 100) / @threshold.threshold)
          @approved_thresholds << @approved_threshold
        end
      end
    end
    @own_ideas = Idea.find(:all, :conditions => { :user_id => @user.id, :archive_status => false})
    @own_thresholds = Array.new
    @own_ideas.each do |idea|
      @v = VoteCount.find(:first, :conditions => { :idea_id => idea.id})
      @own_threshold = ((@v.prev_day_votes * 100) / @threshold.threshold)
      @own_thresholds << @own_threshold
    end
    @approved_counter = 0
    @own_counter = 0
    respond_to do |format|
      format.html
      format.js
    end
  end

  #Method to render chosen tag id to graph
  #+params[:tag_id] + id of the tag the user clicks on
  #Author:Lina Basheer

  def getideas
    @tagid = params[:tagid]
    respond_to do |format|
      format.html
      format.js
    end
  end

  #Method that gets all tags belonging to an idea,
  #+params[:idea_id]+ is the id of the idea the user clicks on
  #Author: Mohamed Salah Nazir

  def gettags
    @ideaid = params[:ideaid]
    @ideatagsthen = IdeasTags.find(:all, :conditions => {:idea_id => @ideaid})
    @ideatags = Tag.where(:id => @ideatagsthen.map(&:tag_id))
    respond_to do |format|
      format.html
      format.js
    end
  end

  #Method to get ideas in chosen tag
  #+params[:tag_id] + id of the tag the user clicks on
  #Author:Lina Basheer
  def chart_data
    @tagid = params[:tag_id]
    @ideastagsall = IdeasTags.find(:all, :conditions => {:tag_id => @tagid})
    @ideasall = Idea.find(:all, :conditions => {:id => @ideastagsall.map(&:idea_id) }, :order=> 'num_votes desc', :limit=>20)
    @user_ideas = Idea.find(:all, :conditions => {:id => @ideastagsall.map(&:idea_id) , :user_id => current_user.id})
    @ideasall = (@ideasall + @user_ideas).uniq
    respond_to do |format|
      format.csv
    end
  end

end