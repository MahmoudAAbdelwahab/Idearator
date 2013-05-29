class EditCompetitionNotification < CompetitionNotification
  inherits_from :notification

  def self.send_notification (user_sender, competition, users_receivers)
    edit_competition_notification = EditCompetitionNotification.create(user: user_sender, competition: competition, users: users_receivers)
    NotificationsController::CoolsterPusher.new.push_notification users_receivers, edit_competition_notification

  end

  def text
    competition = Competition.find(self.competition_id)
    competition.investor.username + " edited his competition " + competition.title + "."
  end

end