require 'spec_helper'

describe CreateCompetitionNotification do
  before :each do
    @user = FactoryGirl.create(:investor)
    @user.confirm!
    @competition = FactoryGirl.create(:notification_competition)
    @competition.investor = @user
    @competition.save
    @notification = CreateCompetitionNotification.create(user: @user, competition: @competition, users: [@user])
  end

  describe 'send_notification' do

    it 'adds create competition notification to competition_notifications table'do
      CreateCompetitionNotification.send_notification(@user, @competition, [@user])
      expect(CompetitionNotification.last.type).to eq('CreateCompetitionNotification')
      expect(CompetitionNotification.last.competition_id).to eq(@competition.id)
      expect(CompetitionNotification.last.user_id).to eq(@user.id)
      expect(CompetitionNotification.last.users).to include(@user)
    end

    it 'adds create competition notification to notifications table' do
      expect(Notification.last.subtype).to eq ('CreateCompetitionNotification')
    end

  end

  describe 'text' do

    it 'returns the notifications text'do
      expect(@notification.text).to eq('investor created a new competition title.')
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
