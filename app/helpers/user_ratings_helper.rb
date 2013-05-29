module UserRatingsHelper

  # passes either newely created or the existing user rating ballot to the user_ratings/_form.html.erb
  # Params:
  # +rating_id+:: is the id of the instance of +Rating+, i.e Rating Perspective, which is being rated
  # Authour: Mahmoud Abdelghany Hashish
  def rating_ballot(rating_id)
    if user_rating = current_user.user_ratings.find_by_rating_id(rating_id)
      user_rating
    else
      current_user.user_ratings.new
    end
  end

  # passes the existing user rating value, else string 'N/A', of a certain perspective to the user_ratings/_form.html.erb
  # Params:
  # +rating_id+:: is the id of the instance of +Rating+, i.e Rating Perspective, which is being rated
  # Author: Mahmoud Abdelghany Hashish
  def current_user_rating(rating_id)
    if user_rating = current_user.user_ratings.find_by_rating_id(rating_id)
      user_rating.value
    else
      'N/A'
    end
  end
end