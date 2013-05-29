require 'spec_helper'

describe EditCompetitionNotification do
  before :each do
    @user = FactoryGirl.create(:investor)
    @user.confirm!
    @competition = FactoryGirl.create(:notification_competition)
    @competition.investor = @user
    @competition.save
    @notification = EditCompetitionNotification.create(user: @user, competition: @competition, users: [@user])
  end

  describe 'send_notification' do

    it 'adds edit competition notification to competition_notifications table'do
      EditCompetitionNotification.send_notification(@user, @competition, [@user])
      expect(CompetitionNotification.last.type).to eq('EditCompetitionNotification')
      expect(CompetitionNotification.last.competition_id).to eq(@competition.id)
      expect(CompetitionNotification.last.user_id).to eq(@user.id)
      expect(CompetitionNotification.last.users).to include(@user)
    end

    it 'adds edit competition notification to notifications table' do
      expect(Notification.last.subtype).to eq ('EditCompetitionNotification')
    end

  end

  describe 'text' do

    it 'returns the notifications text'do
      expect(@notification.text).to eq('investor edited his competition title.')
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
