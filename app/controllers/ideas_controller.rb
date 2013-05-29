class IdeasController < ApplicationController

  before_filter :authenticate_user!, :only => [:new ,:create , :edit, :update, :vote, :unvote]


  # view idea of current user
  # Params:
  # +id+:: is passed in params through the new idea view, it is used to identify the instance of +Idea+ to be viewed
  # Author: Marwa Mehanna
  def show
    @idea = Idea.find(params[:id])
    if user_signed_in?
      @user = current_user.id
      @username = current_user.username
      @tags = Tag.all
      @chosentags = Idea.find(params[:id]).tags
      @competitions = Competition.joins(:tags).where('tags.id' => @idea.tags)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @idea }
      end
    end
  end

  # making new Idea
  # Params: None
  # Author: Marwa Mehanna
  def new
    @idea = Idea.new
    @tags = Tag.all
    @chosentags = []
    @competition = params[:competition_id]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @idea }
    end
  end

  # filters the ideas that have one or more of given tags
  # Params:
  # +tags+:: the parameter is an list of +Tag+ passed through tag autocomplete field
  # Author: muhammed hassan
  def filter
    @approved = Idea.joins(:tags).where(:tags => {:name => params[:myTags]}).uniq.page(params[:page]).per(10)
    @tags = params[:myTags]
    respond_to do |format|
      format.js
      format.json  { render :json => @approved }
    end
  end

  # editing Idea
  # Params:
  # +id+:: this is an instance of +Idea+ passed through _form.html.erb, used to identify which +Idea+ to edit
  # Author: Marwa Mehanna
  def edit
    @idea = Idea.find(params[:id])
    @tags = Tag.all
    @chosentags = Idea.find(params[:id]).tags
    @boolean = true
  end

  # updating Idea
  # Params:
  # +id+:: this is an instance +Idea+ passed through _form.html.erb, used to identify which +Idea+ to  update
  # +id+:: this is an instance +Idea+ passed through show.html.erb, used to identify which is +Idea+ to update
  # Author: Marwa Mehanna
  def update
    @idea = Idea.find(params[:id])
    @idea.send_edit_notification current_user
    respond_to do |format|
      if @idea.update_attributes(params[:idea])
        if current_user.provider == 'twitter' && current_user.facebook_share
          current_user.twitter.update("I've updated my idea on #Idearator ! available on: http://apps.facebook.com/idearator/" + @idea.id.to_s) rescue Twitter::Error
        end
        format.html { redirect_to @idea, :notice => 'Idea was successfully updated.' }
        format.json { respond_with_bip(@idea) }
      else
        format.html { render :action => 'edit' }
        format.json { respond_with_bip(@idea) }
      end
    end
  end

  # Votes for a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be voted
  # Author: Marwa Mehannna
  def vote
    @idea = Idea.find(params[:id])
    current_user.vote_for @idea
    @idea.reload
    respond_to do |format|
      if current_user.provider == 'twitter' && current_user.facebook_share
        current_user.twitter.update("I've voted to an idea on #Idearator ! available on: http://apps.facebook.com/idearator/" + @idea.id.to_s) rescue Twitter::Error
      end
      format.html { redirect_to @idea, :notice =>'Thank you for voting' }
      format.json { head :no_content }
      format.js
    end
  end

  # UnVotes for a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be unvoted
  # Author: Marwa Mehannna
  def unvote
    @idea = Idea.find(params[:id])
    current_user.unvote_for @idea
    @idea.reload
    respond_to do |format|
      format.html { redirect_to @idea, :notice =>'Your vote is deleted' }
      format.json { head :no_content }
      format.js
    end
  end

  # creating new Idea
  # Params:
  # +idea+:: this is an instance of +Idea+ passed through _form.html.erb, identifying the idea which will be added to records
  # Author: Marwa Mehanna
  def create
    @idea = Idea.new(params[:idea])
    @idea.user_id = current_user.id
    respond_to do |format|
      if @idea.save
        VoteCount.create(idea_id: @idea.id)
        if params[:competition_id] != '' and params[:competition_id] != nil
          Competition.find(params[:competition_id]).ideas << @idea
        end

        if current_user.provider == 'twitter' && current_user.facebook_share
          current_user.twitter.update("I've created a new idea on #Idearator ! available on: http://apps.facebook.com/idearator/" + @idea.id.to_s) rescue Twitter::Error
        end
        format.html { redirect_to @idea, notice: 'idea was successfully created.' }
        format.json { render json: @idea, status: :created, location: @idea }
      else
        format.html { render action: 'new' }
        format.json { render json: @idea.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deletes all records related to a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be archived
  # Author: Mahmoud Abdelghany Hashish
  def destroy
    idea = Idea.find(params[:id])
    if current_user.id == idea.user_id
      DeleteNotification.send_notification(current_user, idea, idea.voters)
      idea.voters.each do |u|
        idea.voters.delete(u)
      end
      list_of_ratings = Rating.where(:idea_id => idea.id)
      list_of_user_ratings = []
      list_of_ratings.each do |r|
        list_of_user_ratings.append(UserRating.where(:rating_id => r.id)).flatten!
      end
      list_of_ratings.each do |r|
        r.destroy
      end
      list_of_user_ratings.each do |ur|
        ur.destroy
      end
      idea.destroy
      respond_to do |format|
        format.html { redirect_to '/', alert: 'Your Idea has been successfully deleted!' }
      end
    else
      respond_to do |format|
        format.html { redirect_to idea, alert: 'You do not own the idea, so it cannot be deleted!' }
      end
    end
  end

  # Archives a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be archived
  # Author: Mahmoud Abdelghany Hashish
  def archive
    idea = Idea.find(params[:id])

    if current_user.type == 'Admin' || current_user.id == idea.user_id
      idea.archive_status = true
      idea.save
      list = idea.voters
      if current_user.type == 'Admin'
        list.append(User.find(idea.user_id)).flatten!
      end
      ArchiveNotification.send_notification(current_user, idea, list)
      idea.voters.each do |u|
        idea.voters.delete(u)
      end
      idea.num_votes = 0
      list_of_ratings = Rating.where(:idea_id => idea.id)
      list_of_user_ratings = []
      list_of_ratings.each do |r|
        list_of_user_ratings.append(UserRating.where(:rating_id => r.id)).flatten!
      end
      list_of_user_ratings.each do |u|
        u.destroy
      end
      idea.save
      respond_to do |format|
        format.html { redirect_to idea, alert: 'Idea has been successfully archived!' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to idea, alert: "Idea isn't archived, you are not allowed to archive it." }
        format.js { head :no_content }
      end
    end
  end

  # Unarchives a specific idea
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be unarchived
  # Author: Mahmoud Abdelghany Hashish
  def unarchive
    idea = Idea.find(params[:id])
    if current_user.type == 'Admin' || current_user.id == idea.user_id
      idea.archive_status = false
      idea.save
      if current_user.provider == 'twitter' && current_user.facebook_share
        current_user.twitter.update("My idea is back to life! =D I've unarchived my idea on #Idearator ! available on: http://apps.facebook.com/idearator/" + idea.id.to_s) rescue Twitter::Error
      end
    else
      respond_to do |format|
        format.html { redirect_to idea, alert: "Idea isn't archived, you are not allowed to archive it." }
        format.js { head :no_content }
      end
    end
  end

  # adds the rating prespectives taken from the user from the add_prespectives view
  # to the idea reviewed
  # Params:
  # +params[:ratings]+:: ratings prespectives taken from the user
  # +session[:idea_id]+:: id of the idea to be reviewed
  # Author: Omar Kassem
  def add_rating
    if current_user.type == 'Committee'
      @idea=Idea.find(params[:id])
      @idea.approved = true
      @idea.save
      @rating = params[:rating]
      @rating.each do |rate|
        r = @idea.ratings.build
        r.name=rate
        r.value=0
        r.idea_id=@idea.id
        r.save
      end
      respond_to do |format|
        format.js {render "add_rating"}
      end
    else
      respond_to do |format|
        format.html { redirect_to  '/' , notice: 'You cant add rating prespectives' }
        format.json { head :no_content }
      end
    end
  end



  # Enters the idea into a chosen Competition
  # Params:
  # +id+:: the parameter is an instance of +Idea+ passed through the enroll_idea partial view
  # +competition_id+:: the parameter is an instance of +Competition+ passed through the enroll_idea partial view
  # Author: Mohammad Abdulkhaliq
  def enter_competition
    @idea = Idea.find(params[:id])
    @competition = Competition.find(params[:competition_id])
    if CompetitionEntry.find(:all, :conditions => {:competition_id => @competition.id, :rejected => false, :idea_id => @idea.id }) == []
      @competition.ideas << @idea
      EnterIdeaNotification.send_notification(@idea.user, @idea, @competition, [@competition.investor])
      respond_to do |format|
        format.html { redirect_to @idea, notice: 'Idea Submitted successfully'}
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @competition, notice: 'This idea is already enrolled in this competiton'}
        format.json { head :no_content }
      end
    end
  end
  # Popover with idea details
  # Params:
  # +id+:: is used to specify the instance of +Idea+ to be displayed
  # Author: Dayna Hany
  def popover
    @idea = Idea.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

end

