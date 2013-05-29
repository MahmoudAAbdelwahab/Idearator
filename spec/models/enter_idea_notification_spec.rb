require 'spec_helper'

describe EnterIdeaNotification do
  before :each do
    @user = FactoryGirl.create(:investor)
    @user.confirm!
    @idea = FactoryGirl.create(:idea)
    @competition = FactoryGirl.create(:notification_competition)
    @competition.investor = @user
    @competition.save
    @notification = EnterIdeaNotification.create(user: @user,idea: @idea, competition: @competition, users: [@user])
  end

  describe 'send_notification' do

    it 'adds enter idea notification to competition_idea_notifications table'do
      EnterIdeaNotification.send_notification(@user,@idea, @competition, [@user])
      expect(CompetitionIdeaNotification.last.type).to eq('EnterIdeaNotification')
      expect(CompetitionIdeaNotification.last.competition_id).to eq(@competition.id)
      expect(CompetitionIdeaNotification.last.user_id).to eq(@user.id)
      expect(CompetitionIdeaNotification.last.users).to include(@user)
    end

    it 'adds enter idea notification to notifications table' do
      expect(Notification.last.subtype).to eq ('EnterIdeaNotification')
    end

  end

  describe 'text' do

    it 'returns the notifications text'do
      expect(@notification.text).to eq('An idea was enrolled in your competition title.')
    end
  end

  describe 'read_by?' do

    it 'returns the value of the read variable'do
      notification_user= NotificationsUser.find(:first, :conditions => {notification_id: @notification.id, user_id: @user.id })
      expect(@notification.read_by?(@user)).to eq(notification_user.read)
    end

  end

  describe 'set_read_for' do

    it 'sets the value of read to true'do
      @notification.set_read_for(@user)
      notification_user= NotificationsUser.find(:first, :conditions => {notification_id: @notification.id, user_id: @user.id })
      expect(notification_user.read).to eq(true)
    end

  end

end
