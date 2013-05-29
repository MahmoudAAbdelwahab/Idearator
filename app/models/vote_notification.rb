class VoteNotification < IdeaNotification
  inherits_from :notification

  def self.send_notification (user_sender, idea, users_receivers)
    vote_notification = VoteNotification.create(user: user_sender, idea: idea, users: users_receivers)
    NotificationsController::CoolsterPusher.new.push_notification users_receivers, vote_notification
  end

  def text
    "Your idea " + Idea.find(self.idea_id).title + " got a vote."
  end

end
