class EditNotification < IdeaNotification
  inherits_from :notification

  def self.send_notification(user_sender, idea, users_receivers)
    edit_notification = EditNotification.create(user: user_sender, idea: idea, users: users_receivers)
    NotificationsController::CoolsterPusher.new.push_notification users_receivers, edit_notification
  end

  def text
    User.find(self.user_id).username + " edited his idea " + Idea.find(self.idea_id).title + "."
  end

end
