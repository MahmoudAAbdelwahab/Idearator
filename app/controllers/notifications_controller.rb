class NotificationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:view_notifications]

  class CoolsterPusher < AbstractCoolsterPusher

    def push_notification(users, notification)
      user_ids = users.collect { |u| u.id.to_s }
      Coolster.update_each(user_ids) do |user_id|
        count = User.find(user_id).unread_notifications_count
        render 'notifications/add_notification',
              locals: { notification: notification, read: false, count: count}
      end
    end

  end

  # gets all current users notifications.
  # Params: none.
  # Author: Amina Zoheir
  def view_all_notifications
  end

  # sets the read field to true for the specified notification and redirects to ideas#show.
  # Params:
  # +not_id+:: the parameter is an integer passed through notifications/_view.
  # Author: Amina Zoheir
  def redirect_idea
    notification = Notification.find(params[:notification])
    notification.set_read_for current_user
    respond_to do |format|
      format.js { render 'redirect', locals:{path: '/ideas/' + ((notification.idea.id).to_s)} }
      format.json { head :no_content }
    end
  end

  # sets the read field to true for the specified notification and redirects to users#send_expertise.
  # Params:
  # +notification+:: the parameter is an integer passed through the notifications/_view.
  # Author: Amina Zoheir
  def redirect_expertise
    notification = Notification.find(params[:notification])
    notification.set_read_for current_user
    respond_to do |format|
      format.js { render 'redirect_expertise' }
      format.json { head :no_content }
    end
  end

  # sets the read field to true for the specified notification and redirects to cusers#show.
  # Params:
  # +notification+:: the parameter is an integer passed through notifications/_view.
  # Author: Amina Zoheir
  def redirect_review
    notification = Notification.find(params[:notification])
    notification.set_read_for current_user
    respond_to do |format|
      format.js { render 'redirect', locals:{path: '/users/' + (notification.user.becomes(User).id).to_s} }
      format.json { head :no_content }
    end
  end

  # sets the read field to true for the specified notification.
  # Params:
  # +notification+:: the parameter is an integer passed through notifications/_view.
  # Author: Amina Zoheir
  def set_read
    notification = Notification.find(params[:notification])
    notification.set_read_for current_user
    respond_to do |format|
      format.js { render 'layouts/update_nav_bar' }
    end
  end

  # sets the read field to true for the specified notification and redirects to competition#show.
  # Params:
  # +notification+:: the parameter is an integer passed through notifications/_view.
  # Author: Amina Zoheir
  def redirect_competition
    notification = Notification.find(params[:notification])
    notification.set_read_for current_user
    respond_to do |format|
      format.js { render 'redirect', locals:{path: '/competitions/' + ((notification.competition.id).to_s)} }
      format.json { head :no_content }
    end
  end

  # sets the read field to true for the specified notification and redirects to competition#review_competition.
  # Params:
  # +notification+:: the parameter is an integer passed through notifications/_view.
  # Author: Amina Zoheir
  def redirect_stream
    notification = Notification.find(params[:notification])
    notification.set_read_for current_user
    respond_to do |format|
      format.js { render 'redirect_review', locals:{idea_id: notification.idea.id, id: notification.competition.id } }
      format.json { head :no_content }
    end
  end

end
