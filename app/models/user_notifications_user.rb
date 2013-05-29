class UserNotificationsUser < ActiveRecord::Base

  attr_accessible :read

  belongs_to :user_notification
  belongs_to :user
end
