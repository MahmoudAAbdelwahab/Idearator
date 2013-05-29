class CompetitionsController < ApplicationController

  before_filter :authenticate_user!, :only => [:new ,:create , :edit, :update, :enroll_idea]
  # view stream of competitiions
  # Params
  # +Page+:: is passed in params through the new competition.js , it is used to load instances of +Competition+ to be viewed
  # +tags+:: is passed in params through the new competition.js , it is used to filter instances of +Competition+ to be viewed
  # Muhammed Hassan
  def index
    @type = 2
    @firstTime = false
    all = Competition
    if params[:type]
      @firstTime = true
    end
    if (params[:types] =="1")
      if user_signed_in? and current_user.is_a? Investor
        all = Competition.joins(:investor).where(:users => {:id => current_user.id})
        @type = 1
      end
    elsif  ( params[:types] =="3")
      @type = 3
      all = Competition.joins(:ideas).where(:ideas =>{:user_id => current_user.id})
    elsif  ( params[:types] =="2")
      @type = 2
    end
    if (params[:type] =="1")
      if user_signed_in? and current_user.is_a? Investor
        all = Competition.joins(:investor).where(:users => {:id => current_user.id})
        @type = 1
      end
    elsif  ( params[:type] =="3")
      @flag = true
      @type = 3
      all = Competition.joins(:ideas).where(:ideas =>{:user_id => current_user.id})
    elsif  ( params[:type] =="2")
      @type = 2
    end
    @filter = false
    if(params[:myPage])
      @tags = params[:tags].slice(1,params[:tags].length)
      if(@tags.length ==0)
        @competitions = all.uniq.page(params[:myPage]).per(10)
      else
        @competitions = all.joins(:tags).where(:tags => {:name => @tags}).uniq.page(params[:myPage]).per(10)
      end
    else
      if (params[:tags])
        @filter = true
        @tags = params[:tags].slice(1,params[:tags].length)
        if(@tags.length ==0)
          @competitions = all.uniq.page(1).per(10)
        else
          @competitions = all.joins(:tags).where(:tags => {:name => @tags}).uniq.page(1).per(10)
        end
      else
        @firstTime = true
        @competitions = all.uniq.page(1).per(10)
      end
    end
    respond_to do |format|
      format.js
    end
  end

#This method renders the modal for reviewing ideas through notifications
  #Params
  #+idea_id+id of the idea to be reviewed
  #+id+ id of the competition
  #Author Omar Kassem
  def notification_review
    @approved=Idea.find(params[:idea_id])
    @competition=Competition.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  #This method renders the stream of the unapproved ideas of certain competition
  #Params
  #+id+ id of the competition
  #Author Omar Kassem
  def review_competitions_ideas
    @competition = Competition.find(params[:id])
    if current_user != nil && current_user.id == @competition.investor_id
      @ideas = CompetitionEntry.find(:all,:conditions =>{:approved => false, :rejected => false, :competition_id => @competition.id})
      @ideas.map!{|id| Idea.find(id.idea_id)}
    else
      respond_to do |format|
        format.html { redirect_to  '/' , notice: 'You can not review ideas' }
        format.json { head :no_content }
      end
    end
  end

  #This method approves the idea chosen by the investor to be approved
  #Params
  #+idea_id+id of the idea to be reviewed
  #+id+ id of the competition
  #Author Omar Kassem
  def approve
    @idea = Idea.find(params[:idea_id])
    @competition = Competition.find(params[:id])
    if current_user != nil && current_user.id == @competition.investor_id
      @entry = CompetitionEntry.find(:all,:conditions => {:competition_id => @competition.id,:idea_id => @idea.id})
      @entry.each do |entry|
        entry.approved=true
        entry.save
      end
      @competition = Competition.find(params[:id])
      @competition.ideas.uniq
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to  '/' , notice: 'You can not approve ideas' }
        format.json { head :no_content }
      end
    end
  end

  #This method rejects the idea chosen by the investor to be rejected
  #Params
  #+idea_id+id of the idea to be reviewed
  #+id+ id of the competition
  #Author Omar Kassem
  def reject
    @idea = Idea.find(params[:idea_id])
    @competition = Competition.find(params[:id])
    if current_user != nil && current_user.id == @competition.investor_id
      @entry = CompetitionEntry.find(:all,:conditions => {:competition_id => @competition.id,:idea_id => @idea.id})
      @entry.each do |entry|
        entry.rejected=true
        entry.save
      end
      @competition = Competition.find(params[:id])
      @competition.ideas.uniq
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to  '/' , notice: 'You can not reject ideas' }
        format.json { head :no_content }
      end
    end
  end

  # view competition of current user
  # Params
  # +id+:: is passed in params through the new competition view, it is used to identify the instance of +Competition+ to be viewed
  # Marwa Mehanna
  def show
    @competition = Competition.find(params[:id])
    @chosen_tags_competition = Competition.find(params[:id]).tags
    if (user_signed_in?)
      @myIdeas=User.find(current_user).ideas.find(:all, :conditions =>{:rejected => false})
      @myIdeas.reject! do |i|
        (@competition.tags & i.tags).empty?
      end
    end
    @ideas=@competition.ideas.page(params[:mypage]).per(4)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @competition }
      format.js
    end
  end

  # making new Competition
  # Params: None
  # Author: Marwa Mehanna
  def new
    @competition = Competition.new
    chosen_tags_competition=[]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @competition }
    end
  end

  ## editing Idea
  # Params
  # +id+ :: this is an instance of +Competition+ passed through _form.html.erb, used to identify which +Competition+ to edit
  # Author: Marwa Mehanna
  def edit
    @competition = Competition.find(params[:id])
    @chosen_tags_competition = Competition.find(params[:id]).tags
  end

  # creating new Idea
  # Params
  # +competition+ :: this is an instance of +Competition+ passed through _form.html.erb, identifying the competition which will be added to records
  # Author: Marwa Mehanna
  def create
    @competition = Competition.new(params[:competition])
    @competition.investor_id = current_user.id
    @competition.filter
    @competition.send_create_notification current_user
    respond_to do |format|
      if @competition.save
        format.html { redirect_to @competition, notice: 'Competition was successfully created.' }
        format.json { render json: @competition, status: :created, location: @competition }
      else
        format.html { render action: "new" }
        format.json { render json: @competition.errors, status: :unprocessable_entity }
      end
    end
  end

  # updating Idea
  # Params
  # +id+ :: this is an instance of +Competition+ passed through _form.html.erb, used to identify which +Competition+ to edit
  # Author: Marwa Mehanna
  def update
    @competition = Competition.find(params[:id])
    @competition.send_edit_notification current_user
    respond_to do |format|
      if @competition.update_attributes(params[:competition])
        format.html { redirect_to @competition, :notice => 'Competition was successfully updated.' }
        format.json { respond_with_bip(@competition) }
      else
        format.html { render :action => 'edit' }
        format.json { respond_with_bip(@competition) }
      end
    end
  end

  # Deletes all records related to a specific idea
  # Params:
  # +id+:: is used to specify the instance of +competition+ to be deleted
  #Author: Marwa Mehanna
  def destroy
    @competition = Competition.find(params[:id])
    if current_user.id == @competition.investor_id
      @competition.send_delete_notification current_user
      @competition.destroy
      respond_to do |format|
        format.html { redirect_to '/', alert: 'Your Competition has been successfully deleted!' }
      end
    else
      respond_to do |format|
        format.html { redirect_to idea, alert: 'You do not own the idea, so it cannot be deleted!' }
      end
    end
  end

  # Enrolls a chosen Idea into a competition
  # Params:
  # +id+:: the parameter is an instance of +Competition+ passed through the enroll_idea partial view
  # +idea_id+:: the parameter is an instance of +Idea+ passed through the enroll_idea partial view
  # Author: Mohammad Abdulkhaliq
  def enroll_idea
    @idea = Idea.find(params[:idea_id])
    @competition = Competition.find(params[:id])
    if CompetitionEntry.find(:all, :conditions => {:competition_id => @competition.id, :rejected => false, :idea_id => @idea.id }) == []
      @competition.ideas << @idea
      #@idea.competitions << @competition
      EnterIdeaNotification.send_notification(@idea.user, @idea, @competition, [@competition.investor])
      respond_to do |format|
        format.html { redirect_to @competition, notice: 'Idea Submitted successfully'}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @competition, notice: 'This idea is already enrolled in this competiton'}
        format.json { head :no_content }
      end
    end
  end
end
