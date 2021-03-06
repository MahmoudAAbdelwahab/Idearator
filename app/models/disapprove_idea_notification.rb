class DisapproveIdeaNotification < IdeaNotification
  inherits_from :notification

  def self.send_notification(user_sender, idea, users_receivers)
    disapprove_notification = DisapproveIdeaNotification.create(user: user_sender, idea: idea, users: users_receivers)
    NotificationsController::CoolsterPusher.new.push_notification users_receivers, disapprove_notification
  end

  def text
    "Your idea " + Idea.find(self.idea_id).title + " wasn't approved by the committee."
  end

end
