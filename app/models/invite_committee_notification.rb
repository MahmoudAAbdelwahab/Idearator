class InviteCommitteeNotification < UserNotification
  inherits_from :notification

  def self.send_notification(user_sender, users_receivers)
    invite_notification = InviteCommitteeNotification.create(user: user_sender, users: users_receivers)
    NotificationsController::CoolsterPusher.new.push_notification users_receivers, invite_notification
  end

  def text
    "You have been invited to become a committee member."
  end

end
