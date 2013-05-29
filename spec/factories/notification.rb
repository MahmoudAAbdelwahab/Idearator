require 'faker'
require 'factory_girl_rails'

FactoryGirl.define do
  factory :vote_notification, :class => IdeaNotification do |f|
    f.type 'VoteNotification'
  end

  factory :edit_notification, :class => IdeaNotification do |f|
    f.type 'EditNotification'
  end

  factory :archive_notification, :class => IdeaNotification do |f|
    f.type 'ArchiveNotification'
  end

  factory :delete_notification, :class => DeleteNotification do |f|

  end

  factory :disapprove_idea_notification, :class => IdeaNotification do |f|
    f.type 'DisapproveIdeaNotificaton'
  end

  factory :approve_committee_notification, :class => UserNotification do |f|
    f.type 'ApproveCommitteeNotification'
  end

  factory :invite_committee_notification, :class => UserNotification do |f|
    f.type 'InviteCommitteeNotification'
  end

  factory :create_competition_notification, :class => CompetitionNotification do |f|
    f.type 'CreateCompetitionNotification'
  end

  factory :enter_idea_notification, :class => CompetitionIdeaNotification do |f|
    f.type 'EnterIdeaNotification'
  end

end
