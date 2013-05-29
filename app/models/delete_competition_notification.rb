class DeleteCompetitionNotification < ActiveRecord::Base
  inherits_from :notification

  belongs_to :user
  belongs_to :competition
  attr_accessible :user, :idea, :competition_title, :users

  # creates new DeleteCompetitionNotification and pushes the notification to the online receivers
  # Params:
  # +user_sender+:: the parameter is an instance of +User+.
  # +competition+:: the parameter is an instance of +Competition+.
  # +users_receivers+:: the parameter is an array of instances of +User+.
  # Author: Amina Zoheir
  def self.send_notification(user_sender,competition, users_receivers)
    delete_competition_notification = DeleteCompetitionNotification.create(user: user_sender,competition: competition, competition_title: competition.title, users: users_receivers)
    NotificationsController::CoolsterPusher.new.push_notification users_receivers, delete_competition_notification
  end

  # returns notification text
  # Params: none
  # Author: Amina Zoheir
  def text
    User.find(self.user_id).username + " deleted his competition " + self.competition_title + "."
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
