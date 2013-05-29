class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #username is unique
  validates :username, :uniqueness => true

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook, :twitter]

  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :username, :date_of_birth, :type, :active, :first_name, :last_name,
    :gender, :about_me, :recieve_vote_notification, :banned,
    :recieve_comment_notification, :provider, :uid, :photo, :approved, :authentication_token, :secret, :facebook_share

  has_many :sent_idea_notifications, class_name: 'IdeaNotification', :dependent => :destroy
  has_many :sent_user_notifications, class_name: 'UserNotification', :dependent => :destroy
  has_many :sent_competition_notifications, class_name: 'CompetitionNotification', :dependent => :destroy
  has_many :sent_competition_idea_notifications, class_name: 'CompetitionIdeaNotification', :dependent => :destroy
  has_many :delete_competition_notifications, :dependent => :destroy
  has_many :delete_notifications, :dependent => :destroy
  has_many :sent_notifications, class_name: 'Notification'
  has_many :ideas
  has_many :comments
  has_many :user_ratings
  has_many :notifications_users
  has_many :notifications, :through => :notifications_users
  has_many :authorizations
  has_many :likes
  has_many :comments, :through => :likes
  has_many :votes
  has_many :voted_ideas, :through => :votes, :source => :idea


  has_attached_file :photo, :styles => { :small => '60x60>', :medium => '300x300>', :thumb => '10x10!' }, :default_url => 'user-default.png'

  # this method finds the +User+ using the hash and creates a new +User+
  # if no users with this email exist
  #
  # Params:
  #
  # +auth+:: omniauth authentication hash
  # +signed_in_resource+:: Currently signed in resource. Unused.
  #
  #Author: Menna Amr
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(username:auth.extra.raw_info.username,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20],
                         authentication_token: auth['credentials']['token'])
    end
    user
  end

  def self.search(search)
    if search
      where('username LIKE  ? AND banned  = ? AND active = ?', "%#{search}%", false,true)
    else
      find(:all)
    end
  end

  # Find a +User+ by the twitter auth data. Uses +provider+ and +uid+ fields to
  # find the user.
  # Params:
  # +auth+:: omniauth authentication hash
  # +signed_in_resource+:: Currently signed in resource. Unused.
  #
  # Author: Mina Nagy
  def self.find_for_twitter_oauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    unless user
      # FIXME handle failure
      user = create_user_from_twitter_oauth(auth)
    end
    user
  end

  # Try to create a +User+ from the twitter authentication hash
  # Params:
  # +auth+:: omniauth authentication hash
  #
  # Author: Mina Nagy
  def self.create_user_from_twitter_oauth(auth)
    name = auth.info.name.split(' ', 2)
    user = User.create(first_name: name[0],
     last_name: name[1],
     provider: auth.provider,
     uid: auth.uid,
                       # this is an invalid email, but uniqueness is guaranteed
                       email: "#{auth.info.nickname}@twitter.com",
                       username: (auth.chosen_user_name or auth.info.nickname),
                       # random password, won't hurt
                       password: Devise.friendly_token[0, 20],
                       authentication_token: auth['credentials']['token'],
                       secret: auth['credentials']['secret'])
  end

  def new_notifications(after)
    notifications = Notification.joins(:notifications_users).where('notifications_users.user_id = ? and created_at > ?', self.becomes(User), Time.at(after.to_i + 1))
    sorted_notifications = notifications.sort_by &:created_at
    new_notifications = sorted_notifications.reverse
  end

  def get_notifications
    notifications = self.notifications
    sorted_notifications = notifications.sort_by &:created_at
    all_notifications = sorted_notifications.reverse
  end

  def unread_notifications_count
    NotificationsUser.find(:all, :conditions => {user_id: self.id, read: false }).length
  end

  # It returns a Twitter Client object, new one if none exists
  # Params: none
  # Author: Mahmoud Abdelghany Hashish
  def twitter
    unless @twitter_user
      @twitter_user = Twitter::Client.new(:oauth_token => self.authentication_token, :oauth_token_secret => self.secret) rescue nil
    end
    @twitter_user
  end

  # Get approved and unarchived ideas for user
  # Params:
  # None
  # Author: Hisham ElGezeery
  def get_approved_ideas
    ideas = self.ideas
    approved_ideas = ideas.where(:approved => true)
    unarchived_ideas = approved_ideas.where(:archive_status => false).all
  end

  # user votes for a certain idea and send notification to owner of the idea.
  # Params:
  # +idea+:: the parameter instance of idea
  # Author:: Marwa Mehanna
  def vote_for(idea)
    self.votes.create(idea_id: idea.id)
    if idea.user.own_idea_notifications
      VoteNotification.send_notification(self, idea, [idea.user])
    end
    idea.save
  end

  # user unvotes for a certain idea
  # Params:
  # +idea+:: the parameter instance of idea
  # Author:: Marwa Mehanna
  def unvote_for(idea)
    voted_ideas.delete(idea)
    t = Idea.find(idea.id).trend
    if t.trending > 4
      t.trending = t.trending - 4
    else
      t.trending = 0
    end
    t.save
  end

  # checks if user voted for this idea
  # Params:
  # +idea+:: the parameter instance of idea
  # Author:: Marwa Mehanna
  def voted_for?(idea)
    votes.where(idea_id: idea.id).exists?
  end

end
