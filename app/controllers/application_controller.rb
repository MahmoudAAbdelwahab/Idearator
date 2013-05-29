class ApplicationController < ActionController::Base

  before_filter :authenticate_user!, :only => [:load_notifications, :update_nav_bar]
  before_filter :load_notifications
  before_filter :banned?

  protect_from_forgery

  # gets first 10 current users notifications and the number of unread notificaations.
  # Params: none.
  # Author: Amina Zoheir
  def load_notifications
    if user_signed_in?
      @all_notifications = current_user.get_notifications
      @notifications = @all_notifications.first(10)
      @count = current_user.unread_notifications_count
    end
  end

  # renders update_nav_bar.
  # Params: none.
  # Author: Amina Zoheir
  def update_nav_bar
    respond_to do |format|
      format.js { render 'layouts/update_nav_bar' }
    end
  end

  # Logs user out if they got banned
  #
  # Params: None
  #
  # Author: Menna Amr
  def banned?
    if current_user.present? && current_user.banned?
      sign_out current_user
      flash[:error] = "This account has been suspended."
      root_path
    end
  end
end
