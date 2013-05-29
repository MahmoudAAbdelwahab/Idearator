class HomeController < ApplicationController

  #returns a list of ideas ordered by the date of creation in pages
  #of 10 ideas.
  #Params:
  #+page+:: the parameter is the page user is currently browsing.
  #Author: Hesham Nabil
  #Method gets all ideas, order them in descending order according to number of votes
  #and sends top ten ideas to index view page
  #Author: Lina Basheer
  #ideas stream can be feltered according to selected tags
  #Author: Muhammed Hassan
  #Calls the action index but with the search parameters filtering
  #the @approved to the ideas matching this search
  #Author: Mohamed Salah Nazir
  def index
    @trending = Idea.joins(:trend).order('trending desc').limit(4)
    @page_number = params[:myPage]
    if MonthlyWinner.all.count > 0
      @winners = MonthlyWinner.all.reverse
      first = @winners.shift
      @first = Idea.find(first.idea_id)
    end
    @top = Idea.find(:all, :conditions => { :approved => true }, :order=> 'num_votes desc', :limit=>10)
    @best = Idea.find(:all, :conditions => { :approved => true }, :order=> 'num_votes desc', :limit=>9)
    if(params[:myTags])
      if(params[:myTags].length > 0)
        tags = Array(params[:myTags])
        tags.map! { |e| e.delete(' ') }
        @approved = Idea.joins(:tags).where(:tags => {:name => tags}).page(params[:myPage].to_i).per(10)
      else
        @approved = Idea.order(:created_at).page(params[:myPage]).per(10)
      end
    else
      @approved = Idea.order(:created_at).page(params[:myPage]).per(10)
    end
    respond_to do |format|
      format.js
      format.html # index.html.erb
      format.xml  { render :xml => @approved }
    end
  end

  def search
    if params[:search].length > 0
      @search = Idea.search(params[:search])
      @top = Idea.find(:all, :conditions => { :approved => true }, :order=> 'num_votes desc', :limit=>10)
      respond_to do |format|
        format.html
        format.js
      end
    else
      index
    end
  end

  def searchelse
    if params[:search].length > 0
      @search = Idea.search(params[:search])
      respond_to do |format|
        format.html
        format.js
      end
    end
  end
end
