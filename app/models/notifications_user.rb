class NotificationsUser < ActiveRecord::Base

  attr_accessible :read

  belongs_to :notification
  belongs_to :user
end