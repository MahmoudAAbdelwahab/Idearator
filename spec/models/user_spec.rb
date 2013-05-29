require 'spec_helper'

describe User do
  before :each do
    @user = FactoryGirl.create(:user)
    @user.confirm!
    @investor = FactoryGirl.create(:investor)
    @investor.confirm!
    @idea = FactoryGirl.create(:idea)
    @idea.user = @user
    @competition = FactoryGirl.create(:competition)
    @competition.investor = @investor
    @competition.save
    @notification1 = DisapproveIdeaNotification.create(user: @user, idea: @idea, users: [@user])
    @notification2 = VoteNotification.create(user: @user, idea: @idea, users: [@user])
    @notification3 = InviteCommitteeNotification.create(user: @user, idea: @idea, users: [@user])
    @notification4 = ApproveCommitteeNotification.create(user: @user, idea: @idea, users: [@user])
    @notification5 = CreateCompetitionNotification.create(user: @user, competition: @competition, users: [@user])
    @notification_user = NotificationsUser.find(:first, :conditions => {notification_id: @notification1.id, user_id: @user.id})
    @notification_user.read = true
    @notification_user.save
  end

  describe 'GET get_notifications' do
    it 'gets all users notifications' do
      expect(@user.get_notifications).to eq([@notification5, @notification4, @notification3, @notification2, @notification1])
    end
  end

  describe 'GET unread_notifications_count' do
    it 'gets the number of unread notifications' do
      expect(@user.unread_notifications_count).to eq(4)
    end
  end

end
