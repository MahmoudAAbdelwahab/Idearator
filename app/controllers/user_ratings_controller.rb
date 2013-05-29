class UserRatingsController < ApplicationController
  before_filter :authenticate_user!

  # creates a new user rating
  # Params:
  # +idea_id+:: is the id of the instance of +Idea+ which it's perspective will be rated
  # +rating+:: is the new rating value that will be added to the +UserRating+ table
  # +rating_id+:: is the id of the instance of +Rating+, i.e Rating Perspective, which is being rated
  # Author: Mahmoud Abdelghany Hashish
  def create
    idea = Idea.find_by_id(params[:idea_id])
    user_rating = UserRating.new(params[:rating])
    user_rating.rating_id = params[:rating_id]
    user_rating.user_id = current_user.id

    if user_rating.save
      saved_rating = UserRating.where('rating_id' => params[:rating_id])

      if saved_rating.size != 0
        rating = Rating.find_by_id(params[:rating_id])
        average_rating = 0

        saved_rating.each do |sr|
          average_rating = average_rating.to_i + sr.value.to_i
        end

        if current_user.provider == 'twitter' && current_user.facebook_share
          current_user.twitter.update("I've rated an idea on IDEARATOR! available on: http://apps.facebook.com/idearator/" + idea.id.to_s) rescue Twitter::Error
        end

        rating.value = average_rating.to_f / saved_rating.size.to_f
        rating.save
      end

      respond_to do |format|
        format.html { redirect_to idea, :notice => 'Your rating has been saved successfully!' }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to idea, :alert => 'Your rating has not been saved, please retry!' }
        format.js
      end
    end
  end

  # updates an existing user rating
  # Params:
  # +idea_id+:: is the id of the instance of +Idea+ which it's perspective will be rated
  # +rating+:: is the new rating value that will be updated in the +UserRating+ table
  # +rating_id+:: is the id of the instance of +Rating+, i.e Rating Perspective, which is being rated
  # Author: Mahmoud Abdelghany Hashish
  def update
    idea = Idea.find_by_id(params[:idea_id])
    user_rating = current_user.user_ratings.find_by_rating_id(params[:rating_id])

    if user_rating.update_attributes(params[:rating])
      saved_rating = UserRating.where('rating_id' => params[:rating_id])

      if saved_rating.size != 0
        rating = Rating.find_by_id(params[:rating_id])
        average_rating = 0

        saved_rating.each do |sr|
          average_rating = average_rating.to_i + sr.value.to_i
        end

        rating.value = average_rating.to_f / saved_rating.size.to_f
        rating.save
      end

      respond_to do |format|
        format.html { redirect_to idea_path(idea), :notice => 'Your rating has been updated successfully!' }
        format.js { render text: "" }
      end
    else
      respond_to do |format|
        format.html { redirect_to idea_path(idea), :alert => 'Your rating has not been updated, please retry!' }
        format.js { render text: "" }
      end
    end
  end
end
