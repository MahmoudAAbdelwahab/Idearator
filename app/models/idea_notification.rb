class IdeaNotification < ActiveRecord::Base
  inherits_from :notification

  belongs_to :idea
  belongs_to :user
  attr_accessible :type, :user, :idea, :users

  # creates new IdeaNotification and pushes the notification to the online receivers
  # Params:
  # +user_sender+:: the parameter is an instance of +User+.
  # +idea+:: the parameter is an instance of +Idea+.
  # +users_receivers+:: the parameter is an array of instances of +User+.
  # Author: Amina Zoheir
  def self.send_notification(user_sender, idea, users_receivers)
  end

  # returns notification text
  # Params: none
  # Author: Amina Zoheir
  def text
  end

  # returns the value of the read field for a certain user and this notification
  # Params:
  # +user+:: the parameter is an instance of +User+.
  # Author: Amina Zoheir
  def read_by?(user)
    NotificationsUser.find(:first, :conditions => {notification_id: self.id, user_id: user.id }).read
  end

  # sets the value of the read field for a certain user and this notification to true
  # Params:
  # +user+:: the parameter is an instance of +User+.
  # Author: Amina Zoheir
  def set_read_for(user)
    notification = NotificationsUser.find(:first, :conditions => {notification_id: self.id, user_id: user.id})

    notification.read = true
    notification.save
  end

end
