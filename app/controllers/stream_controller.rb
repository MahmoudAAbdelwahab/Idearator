class StreamController < ApplicationController

  #This is the action that controls the stream through having 4 aparameters manipulated in a way that they change the
  #value of the @ideas that is sent
  # params:
  # +mypage+:: int
  # +search+:: string
  # +tag+:: Intstance of tag
  # +search_user+:: boolean is sent to true to search for users
  # Author: Mohamed Salah Nazir
  @@filter_all = []

  def index
    @best = Idea.find(:all, :conditions => { :approved => true }, :order=> 'num_votes desc', :limit=>9)
    @trending = Idea.joins(:trend).order('trending desc').limit(4)
    @top = Idea.find(:all, :conditions => { :approved => true }, :order=> 'num_votes desc', :limit=>10)
    @page = params[:mypage]
    @searchtext = params[:search]
    @search_with_user = params[:search_user] == "true"
    @searching_with = params[:searchtype] == "true"
    @insert = params[:insert]

    if MonthlyWinner.all.count > 0
      @winners = MonthlyWinner.all.reverse
      first = @winners.shift
      @first = Idea.find(first.idea_id)
    end

    if params[:reset_global]
      @@filter_all = []
    end

    if params[:set_global]
      @@filter_all = params[:tag].to_a
      @filter_tmp = @@filter_all
    else
      @filter_tmp = @@filter_all+params[:tag].to_a
    end

    if @page.nil?
      @@filter_all = []
      if @searchtext.nil?
        @ideas = Idea.order(:created_at).page(params[:mypage]).per(10)
      else
        if !@searching_with
          @ideas = Idea.search(params[:search]).order(:created_at).page(params[:mypage]).per(10)
        else
          @users = User.search(params[:search]).page(params[:mypage]).per(10)
        end
      end
    else
      if @searchtext != "" and @filter_tmp != []
        if !@search_with_user
          @ideas = Idea.filter(@filter_tmp,@searchtext).sort{|i1,i2| i1.created_at <=> i2.created_at}.uniq
          @ideas = Kaminari.paginate_array(@ideas).page(params[:mypage]).per(10)
        end
      else
        if @searchtext != "" and @filter_tmp == []
          @@filter_all = []
          if @search_with_user
            @users = User.search(params[:search]).page(params[:mypage]).per(10)
          else
            puts Idea.search(params[:search])
            @ideas = Idea.search(params[:search]).order(:created_at).page(params[:mypage]).per(10)
          end
        else
          if @searchtext == "" and @filter_tmp != []
            @ideas = Idea.filter(@filter_tmp,"").sort{|i1,i2| i1.created_at <=> i2.created_at}.uniq
            @ideas = Kaminari.paginate_array(@ideas).page(params[:mypage]).per(10)
            @filter_tmp.uniq
          else
            if @search_with_user
              @@filter_all = []
              @users = User.search(params[:search]).page(params[:mypage]).per(10)
            else
              @@filter_all = []
              @ideas = Idea.order(:created_at).page(params[:mypage]).per(10)
            end
          end
        end
      end
    end
  end
end


