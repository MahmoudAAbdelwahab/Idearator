class CommitteesController < ApplicationController

  before_filter :authenticate_user!

  #generates list of ideas to be reviewed by the committee
  #Author : Omar Kassem
  def review_ideas
    @committee=current_user
    if @committee.type == "Committee"
      @ideas=Idea.find(:all, :conditions =>{:approved => false, :rejected => false})
      @ideas.reject! do |i|
        (i.tags & @committee.tags).empty?
      end
    else
      respond_to do |format|
        format.html { redirect_to  '/' , notice: 'You can not review ideas' }
        format.json { head :no_content }
      end
    end
  end

  #sets the approved status of the idea reviewed by the committee member
  #Params
  # +params[:id]+ id of the idea to be disapproved
  #Author : Omar Kassem
  def disapprove
    if current_user.type == 'Committee'
      @idea=Idea.find(params[:id])
      @idea.approved = false
      @idea.rejected = true
      @idea.save
      DisapproveIdeaNotification.send_notification(current_user, @idea, [@idea.user])
      respond_to do |format|
        format.html { redirect_to  '/' , notice: 'The idea has been disapproved' }
        format.js
      end
    end
  end

  # approves the idea being reviewed
  #Params
  # +params[:id]+ id of the idea to be approved
  # Author : Omar Kassem
  def add_prespectives
    if current_user.type == 'Committee'
      @idea=Idea.find(params[:id])
      session[:idea_id]=params[:id]
      @idea.save
    else
      respond_to do |format|
        format.html { redirect_to  '/' , notice: 'You cant add rating prespectives' }
        format.json { head :no_content }
      end
    end
  end

end
