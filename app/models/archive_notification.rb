class ArchiveNotification < IdeaNotification
  inherits_from :notification
  def self.send_notification(user_sender, idea, users_receivers)
    archive_notification = ArchiveNotification.create(user: user_sender, idea: idea, users: users_receivers)
    NotificationsController::CoolsterPusher.new.push_notification users_receivers, archive_notification
  end

  def text
    "The idea " + Idea.find(self.idea_id).title + " got archived."
  end

end
