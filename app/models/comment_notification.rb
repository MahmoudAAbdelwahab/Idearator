class CommentNotification < IdeaNotification
  inherits_from :notification

  def self.send_notification(user_sender, idea, users_receivers)
    comment_notification = CommentNotification.create(user: user_sender, idea: idea, users: users_receivers)
    NotificationsController::CoolsterPusher.new.push_notification users_receivers, comment_notification
  end

  def text
    User.find(self.user_id).username + " commented on your idea " + Idea.find(self.idea_id).title + "."
  end

end
