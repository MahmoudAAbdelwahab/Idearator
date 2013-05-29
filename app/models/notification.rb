class Notification < ActiveRecord::Base
  acts_as_superclass

  has_many :notifications_users, :dependent => :destroy
  has_many :users, :through => :notifications_users
  attr_accessible :users

end