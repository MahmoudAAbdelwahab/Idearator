class IdeaNotificationsUser < ActiveRecord::Base

  attr_accessible :read

  belongs_to :idea_notification
  belongs_to :user
end
